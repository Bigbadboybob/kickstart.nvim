-- render-markdown.nvim custom handler: pipe tables that are wider than the
-- window. Neovim cannot re-flow a wrapped line around concealed / virtual text,
-- so the builtin table renderer falls apart once a row wraps. For those tables
-- we hide the raw rows (conceal_lines) and draw the whole table as virtual
-- lines, with cell text word-wrapped to column widths that fit the window.
-- Tables that fit are left to the builtin renderer. The row under the cursor
-- is shown raw, so editing still works.
local M = {}

local query = vim.treesitter.query.parse('markdown', '(pipe_table) @table')

local HEAD = 'RenderMarkdownTableHead'
local ROW = 'RenderMarkdownTableRow'
local MIN_COL = 6

local width = vim.api.nvim_strwidth

-- Split a raw table row into trimmed cell strings, ignoring pipes that are
-- escaped or inside inline code.
local function split_row(text)
  local cells, cur, in_code, i = {}, {}, false, 1
  while i <= #text do
    local c = text:sub(i, i)
    if c == '\\' and text:sub(i + 1, i + 1) == '|' then
      cur[#cur + 1] = '|'
      i = i + 1
    elseif c == '`' then
      in_code = not in_code
      cur[#cur + 1] = c
    elseif c == '|' and not in_code then
      cells[#cells + 1] = vim.trim(table.concat(cur))
      cur = {}
    else
      cur[#cur + 1] = c
    end
    i = i + 1
  end
  cells[#cells + 1] = vim.trim(table.concat(cur))
  -- leading / trailing pipes produce empty edge cells
  if text:match '^%s*|' then
    table.remove(cells, 1)
  end
  if text:match '|%s*$' then
    table.remove(cells)
  end
  return cells
end

-- Inline markdown -> list of { text, hl } spans. '\n' spans are forced breaks.
local function spans(text, base)
  local out, i, plain = {}, 1, {}
  local function flush()
    if #plain > 0 then
      out[#out + 1] = { table.concat(plain), base }
      plain = {}
    end
  end
  local rules = {
    { '^`([^`]+)`', 'RenderMarkdownCodeInline' },
    { '^%[([^%]]+)%]%([^%)]*%)', 'RenderMarkdownLink' },
    { '^%*%*([^%*]+)%*%*', '@markup.strong' },
    { '^__([^_]+)__', '@markup.strong' },
    { '^%*([^%*%s][^%*]*)%*', '@markup.italic' },
  }
  while i <= #text do
    local matched = false
    local s, e = text:find('^<br%s*/?>', i)
    if s then
      flush()
      out[#out + 1] = { '\n', base }
      i, matched = e + 1, true
    else
      for _, rule in ipairs(rules) do
        local rs, re, inner = text:find(rule[1], i)
        if rs then
          flush()
          out[#out + 1] = { inner, rule[2] }
          i, matched = re + 1, true
          break
        end
      end
    end
    if not matched then
      plain[#plain + 1] = text:sub(i, i)
      i = i + 1
    end
  end
  flush()
  return out
end

-- Spans -> words. A word is a list of { text, hl } pieces with no spaces, so
-- "`code`," stays together when wrapping.
local function words(span_list)
  local out, cur = {}, {}
  local function flush()
    if #cur > 0 then
      out[#out + 1] = cur
      cur = {}
    end
  end
  for _, span in ipairs(span_list) do
    if span[1] == '\n' then
      flush()
      out[#out + 1] = '\n'
    else
      local pos = 1
      while pos <= #span[1] do
        local s, e = span[1]:find('%s+', pos)
        local chunk = span[1]:sub(pos, (s or #span[1] + 1) - 1)
        if #chunk > 0 then
          cur[#cur + 1] = { chunk, span[2] }
        end
        if not s then
          break
        end
        flush()
        pos = e + 1
      end
    end
  end
  flush()
  return out
end

local function word_width(word)
  local w = 0
  for _, piece in ipairs(word) do
    w = w + width(piece[1])
  end
  return w
end

-- Cut a word that is wider than the column into column-sized words.
local function hard_split(word, max)
  local out, cur, cur_w = {}, {}, 0
  for _, piece in ipairs(word) do
    local chars = vim.fn.split(piece[1], '\\zs')
    local buf = {}
    for _, ch in ipairs(chars) do
      local w = width(ch)
      if cur_w + w > max then
        if #buf > 0 then
          cur[#cur + 1] = { table.concat(buf), piece[2] }
          buf = {}
        end
        out[#out + 1] = cur
        cur, cur_w = {}, 0
      end
      buf[#buf + 1] = ch
      cur_w = cur_w + w
    end
    if #buf > 0 then
      cur[#cur + 1] = { table.concat(buf), piece[2] }
    end
  end
  if #cur > 0 then
    out[#out + 1] = cur
  end
  return out
end

-- Words -> wrapped lines, each { pieces = { text, hl }[], width = n }.
local function wrap(word_list, max, base)
  local lines, cur = {}, { pieces = {}, width = 0 }
  local function flush()
    lines[#lines + 1] = cur
    cur = { pieces = {}, width = 0 }
  end
  local function add(word)
    local w = word_width(word)
    if cur.width > 0 and cur.width + 1 + w > max then
      flush()
    end
    if cur.width > 0 then
      cur.pieces[#cur.pieces + 1] = { ' ', base }
      cur.width = cur.width + 1
    end
    vim.list_extend(cur.pieces, word)
    cur.width = cur.width + w
  end
  for _, word in ipairs(word_list) do
    if word == '\n' then
      flush()
    elseif word_width(word) > max then
      for _, part in ipairs(hard_split(word, max)) do
        add(part)
      end
    else
      add(word)
    end
  end
  if cur.width > 0 or #lines == 0 then
    flush()
  end
  return lines
end

-- Fit column widths into `avail`: columns narrower than an even share keep
-- their natural width, the rest split what is left.
local function fit(natural, avail)
  local widths, open, remaining = {}, {}, avail
  for i in ipairs(natural) do
    open[#open + 1] = i
  end
  local changed = true
  while changed and #open > 0 do
    changed = false
    local share = math.floor(remaining / #open)
    for idx = #open, 1, -1 do
      local i = open[idx]
      if natural[i] <= share then
        widths[i] = natural[i]
        remaining = remaining - natural[i]
        table.remove(open, idx)
        changed = true
      end
    end
  end
  for idx, i in ipairs(open) do
    local share = math.floor(remaining / (#open - idx + 1))
    widths[i] = share
    remaining = remaining - share
  end
  return widths
end

local function border(widths, left, mid, right, hl, indent)
  local parts = {}
  for _, w in ipairs(widths) do
    parts[#parts + 1] = ('─'):rep(w + 2)
  end
  return { { indent .. left .. table.concat(parts, mid) .. right, hl } }
end

local function align_cell(line, w, align)
  local fill = w - line.width
  if align == 'right' then
    return fill, 0
  elseif align == 'center' then
    return math.floor(fill / 2), fill - math.floor(fill / 2)
  end
  return 0, fill
end

---@param buf integer
---@param node TSNode
---@param max_width integer
---@param skip table<integer, boolean> rows whose builtin border overlay must go
---@return render.md.Mark[]
local function render_table(buf, node, max_width, skip)
  local rows, delim = {}, nil
  for child in node:iter_children() do
    local kind = child:type()
    local row = child:range()
    local text = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ''
    if kind == 'pipe_table_delimiter_row' then
      delim = { row = row, cells = split_row(text) }
    elseif kind == 'pipe_table_header' or kind == 'pipe_table_row' then
      rows[#rows + 1] = { row = row, head = kind == 'pipe_table_header', cells = split_row(text), text = text }
    end
  end
  if not delim or #rows == 0 then
    return {}
  end

  local overflow = false
  for _, row in ipairs(rows) do
    overflow = overflow or vim.fn.strdisplaywidth(row.text) > max_width
  end
  if not overflow then
    return {}
  end

  local _, start_col = node:range()
  local indent = (' '):rep(start_col)
  local ncols = #delim.cells
  local avail = max_width - start_col - (ncols + 1) - 2 * ncols
  if avail < ncols * MIN_COL then
    return {}
  end

  local aligns = {}
  for i, cell in ipairs(delim.cells) do
    local l, r = cell:sub(1, 1) == ':', cell:sub(-1) == ':'
    aligns[i] = (l and r) and 'center' or (r and 'right' or 'left')
  end

  -- tokenize every cell once, measure natural widths
  local natural = {}
  for i = 1, ncols do
    natural[i] = MIN_COL
  end
  for _, row in ipairs(rows) do
    row.words = {}
    local base = row.head and HEAD or ROW
    for i = 1, ncols do
      local span_list = spans(row.cells[i] or '', base)
      row.words[i] = words(span_list)
      local w = 0
      for _, span in ipairs(span_list) do
        w = span[1] == '\n' and w or w + width(span[1])
      end
      natural[i] = math.max(natural[i], w)
    end
  end
  local widths = fit(natural, avail)

  local lines = { border(widths, '┌', '┬', '┐', HEAD, indent) }
  for r, row in ipairs(rows) do
    local base = row.head and HEAD or ROW
    local cells, height = {}, 1
    for i = 1, ncols do
      cells[i] = wrap(row.words[i], widths[i], base)
      height = math.max(height, #cells[i])
    end
    for l = 1, height do
      local line = { { indent .. '│', base } }
      for i = 1, ncols do
        local cell = cells[i][l] or { pieces = {}, width = 0 }
        local left, right = align_cell(cell, widths[i], aligns[i])
        line[#line + 1] = { (' '):rep(left + 1), base }
        vim.list_extend(line, cell.pieces)
        line[#line + 1] = { (' '):rep(right + 1), base }
        line[#line + 1] = { '│', base }
      end
      lines[#lines + 1] = line
    end
    if r < #rows then
      lines[#lines + 1] = border(widths, '├', '┼', '┤', row.head and HEAD or ROW, indent)
    end
  end
  lines[#lines + 1] = border(widths, '└', '┴', '┘', ROW, indent)

  -- Concealed lines hide their own virtual lines, so the table hangs off the
  -- line before it (or the line after, for a table on the first line).
  local first, last = rows[1].row, math.max(rows[#rows].row, delim.row)
  local anchor ---@type render.md.Mark
  if first > 0 then
    anchor = { conceal = false, start_row = first - 1, start_col = 0, opts = { virt_lines = lines } }
  elseif last + 1 < vim.api.nvim_buf_line_count(buf) then
    anchor = { conceal = false, start_row = last + 1, start_col = 0, opts = { virt_lines = lines, virt_lines_above = true } }
  else
    return {}
  end

  skip[first - 1], skip[last + 1] = true, true
  local marks = { anchor }
  for row = first, last do
    marks[#marks + 1] = { conceal = true, start_row = row, start_col = 0, opts = { conceal_lines = '' } }
  end
  return marks
end

---@param ctx render.md.handler.Context
---@return render.md.Mark[]
function M.parse(ctx)
  local win = vim.fn.bufwinid(ctx.buf)
  if win == -1 or vim.fn.has 'nvim-0.11' == 0 then
    return {}, {}
  end
  local max_width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff
  local marks, skip = {}, {}
  for _, node in query:iter_captures(ctx.root, ctx.buf) do
    vim.list_extend(marks, render_table(ctx.buf, node, max_width, skip))
  end
  return marks, skip
end

-- Full markdown handler: the builtin marks, minus the borders the builtin
-- overlays on the blank lines around a table we redrew, plus our own.
---@param ctx render.md.handler.Context
---@return render.md.Mark[]
function M.handler(ctx)
  local marks, skip = M.parse(ctx)
  for _, mark in ipairs(require('render-markdown.handler.markdown').parse(ctx)) do
    if not (skip and skip[mark.start_row] and mark.opts.virt_text_pos == 'overlay') then
      marks[#marks + 1] = mark
    end
  end
  return marks
end

return M
