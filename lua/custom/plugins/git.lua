return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
  keys = {
    { '<leader>gs', '<cmd>Git<cr>', desc = '[G]it [S]tatus' },
    { '<leader>gb', '<cmd>Git blame<cr>', desc = '[G]it [B]lame' },
    { '<leader>gp', '<cmd>Git push<cr>', desc = '[G]it [P]ush' },
    { '<leader>gl', '<cmd>Git pull<cr>', desc = '[G]it pu[L]l' },
    { '<leader>gw', '<cmd>Gwrite<cr>', desc = '[G]it [W]rite (stage file)' },
  },
}
