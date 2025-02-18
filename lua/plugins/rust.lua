return {
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
		dependencies = "neovim/nvim-lspconfig",
		lazy = false,
		keys = {
			{
				"<leader>re",
				"<cmd> RustLsp expandMacro <cr>",
				desc = "Rust expand macro",
			},
		},
		-- config = function()
		-- 	vim.g.rustaceanvim = {
		-- 		server = {
		-- 			default_settings = {
		-- 				["rust-analyzer"] = {
		-- 					cargo = {
		-- 						extraEnv = {
		-- 							RUSTFLAGS = "-W clippy::all -W clippy::pedantic -W clippy::nursery -W clippy::cargo",
		-- 						},
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 	}
		-- end,
	},
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
			crates.show()
		end,
		keys = {
			{
				"<leader>rcu",
				function()
					require("crates").upgrade_all_crates()
				end,
				desc = "update crates",
			},
		},
	},
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
}
