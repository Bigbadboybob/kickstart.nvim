-- magma (jupyter)
--require("magma-nvim").setup({
--})

vim.keymap.set('n', '<LocalLeader>r', ':MagmaEvaluateOperator<CR>', { silent = true, expr = true })
vim.keymap.set('n', '<LocalLeader>rr', ':MagmaEvaluateLine<CR>', { silent = true })
vim.keymap.set('x', '<LocalLeader>r', ':<C-u>MagmaEvaluateVisual<CR>', { silent = true })
vim.keymap.set('n', '<LocalLeader>rc', ':MagmaReevaluateCell<CR>', { silent = true })
vim.keymap.set('n', '<LocalLeader>rd', ':MagmaDelete<CR>', { silent = true })
vim.keymap.set('n', '<LocalLeader>ro', ':MagmaShowOutput<CR>', { silent = true })

-- Set plugin options
vim.g.magma_automatically_open_output = false
vim.g.magma_image_provider = "kitty"

function MagmaInitPython()
	vim.cmd [[
    :MagmaInit python3
    :MagmaEvaluateArgument a=5
    ]]
end

function MagmaInitCSharp()
	vim.cmd [[
    :MagmaInit .net-csharp
    :MagmaEvaluateArgument Microsoft.DotNet.Interactive.Formatting.Formatter.SetPreferredMimeTypesFor(typeof(System.Object),"text/plain");
    ]]
end

function MagmaInitFSharp()
	vim.cmd [[
    :MagmaInit .net-fsharp
    :MagmaEvaluateArgument Microsoft.DotNet.Interactive.Formatting.Formatter.SetPreferredMimeTypesFor(typeof<System.Object>,"text/plain")
    ]]
end

vim.cmd [[
:command MagmaInitPython lua MagmaInitPython()
:command MagmaInitCSharp lua MagmaInitCSharp()
:command MagmaInitFSharp lua MagmaInitFSharp()
]]

return {}
