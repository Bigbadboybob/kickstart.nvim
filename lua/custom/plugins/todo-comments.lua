return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VimEnter',
  keys = {
    { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odos' },
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
  },
  opts = {},
}
