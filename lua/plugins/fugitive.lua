return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git" },
		keys = {
			{
				"<leader>grh",
				function()
					local cmd = vim.cmd
					cmd("wa!")
					cmd("Git reset --hard")
					cmd("checktime")
				end,
				desc = "Save all buffers, run git reset --hard and reload all buffers",
			},
			{
				"<leader>gaa",
				"<cmd> Git add -A <CR>",
				desc = "Runs git add -A",
			},
			{
				"<leader>gp",
				"<cmd> Git push <CR>",
				desc = "Runs git push",
			},
			{
				"<leader>gc",
				':Git commit -m "',
				desc = "Begins git commit",
			},
		},
	},
}
