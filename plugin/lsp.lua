vim.api.nvim_create_user_command("LspRestart", function()
	vim.cmd("lsp restart")
end, { desc = "Restart LSP servers attached to current buffer" })
