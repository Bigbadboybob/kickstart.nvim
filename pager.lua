-- Minimal Neovim config for Kitty scrollback pager

-- Disable loading plugins, files, etc.
vim.opt.rtp = vim.opt.rtp -- no-op to keep runtime path valid

-- Leader key (not really used here, but avoids plugin assumptions)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Interface settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = 'no'
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.cmdheight = 1
vim.opt.scrolloff = 3
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.termguicolors = true
vim.opt.hlsearch = false

-- Tabs and indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true

-- Disable swap/backup/undo files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

-- Set clipboard off to avoid delays
vim.opt.clipboard = ""

-- File-specific tweaks
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove("cro")
  end,
})

-- Optional: colorscheme
vim.cmd("colorscheme default")

-- Status bar off
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.opt.cmdheight = 1

-- No plugins or LSPs are loaded to avoid errors in pager mode

-- Set scrollback
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.scrollback = 100000
  end,
})
