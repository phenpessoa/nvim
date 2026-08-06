return {
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			vim.lsp.codelens.refresh = function(opts)
				vim.lsp.codelens.enable(true, { bufnr = opts and opts.bufnr })
			end
			vim.lsp.codelens.clear = function(client_id, bufnr)
				vim.lsp.codelens.enable(false, bufnr and { bufnr = bufnr } or { client_id = client_id })
			end

			require("go").setup({
				tag_options = "",
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
		keys = {
			{
				"<leader>gsj",
				"<cmd> GoAddTag json <CR>",
				desc = "Add json struct tags",
			},
			{
				"<leader>gsy",
				"<cmd> GoAddTag yaml <CR>",
				desc = "Add yaml struct tags",
			},
			{
				"<leader>gfs",
				"<cmd> GoFillStruct <cr>",
				desc = "Go Fill Struct",
			},
		},
	},
}
