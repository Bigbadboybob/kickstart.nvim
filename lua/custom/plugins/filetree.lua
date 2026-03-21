-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  -- Default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- Visual mode: mark all selected lines
  vim.keymap.set('v', 'm', function()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    for line = start_line, end_line do
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      api.marks.toggle()
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  end, { buffer = bufnr, desc = 'Bulk mark in visual mode' })
end

require("nvim-tree").setup({
	sort_by = "modification_time",
	on_attach = on_attach,
	renderer = {
		group_empty = true,
	},
	-- filters = {
		-- dotfiles = true,
  --   custom = {"^\\.git"}
	-- },
  git = {
    ignore = false,
  },
})


local function open_nvim_tree()
	-- open the tree
	require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
vim.keymap.set('n', '<LocalLeader>t', ':NvimTreeToggle<CR>', { silent = true, noremap = true })

return {}
