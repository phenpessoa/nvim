return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen" },
		keys = {
			{
				"<leader>gvo",
				"<cmd> DiffviewOpen <CR>",
				desc = "Opens diff view",
			},
			{
				"<leader>gvc",
				"<cmd> DiffviewClose <CR>",
				desc = "Closes diff view",
			},
		},
	},
}
