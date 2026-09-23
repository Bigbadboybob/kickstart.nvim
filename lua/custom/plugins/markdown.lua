-- In-buffer markdown rendering: headings, tables, checkboxes, code blocks,
-- bullet/quote styling — all inside the terminal via treesitter + nerd-font
-- icons. No browser, no external binaries.
--
-- Markdown buffers open unrendered; <leader>md toggles rendering on. While
-- rendered, the buffer drops back to raw text in insert mode (so editing is
-- unobstructed).
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  keys = {
    { '<leader>md', '<cmd>RenderMarkdown toggle<cr>', desc = '[M]ark[d]own render toggle', ft = 'markdown' },
  },
  opts = {
    -- Start unrendered; <leader>md toggles rendering on.
    enabled = false,
    -- Math is rendered as images by snacks.nvim (see image.lua); render-markdown's
    -- unicode latex (needs pylatexenc) would double up, so keep it off.
    latex = { enabled = false },
    -- Keep long analysis tables readable: render the full table chrome.
    pipe_table = { style = 'full' },
    -- Tables wider than the window are redrawn with word-wrapped cells, see
    -- lua/custom/md_table_wrap.lua (it runs the builtin handler for the rest).
    custom_handlers = {
      markdown = {
        parse = function(ctx)
          return require('custom.md_table_wrap').handler(ctx)
        end,
      },
    },
    heading = { icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' } },
    code = { style = 'full', width = 'block', min_width = 60 },
  },
}
