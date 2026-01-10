return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff view' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it repo [H]istory' },
    { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = '[G]it diff [C]lose' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = {
        layout = 'diff2_horizontal',
      },
      merge_tool = {
        layout = 'diff3_horizontal',
      },
    },
    file_panel = {
      listing_style = 'tree',
      win_config = {
        position = 'left',
        width = 35,
      },
    },
    keymaps = {
      view = {
        ['<tab>'] = 'select_next_entry',
        ['<s-tab>'] = 'select_prev_entry',
        ['gf'] = 'goto_file_edit',
        ['<leader>e'] = 'toggle_files',
      },
      file_panel = {
        ['j'] = 'next_entry',
        ['k'] = 'prev_entry',
        ['<cr>'] = 'select_entry',
        ['s'] = 'toggle_stage_entry',
        ['S'] = 'stage_all',
        ['U'] = 'unstage_all',
        ['X'] = 'restore_entry',
        ['R'] = 'refresh_files',
      },
    },
  },
}
