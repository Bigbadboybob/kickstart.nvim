-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
	sort_by = "modification_time",
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
