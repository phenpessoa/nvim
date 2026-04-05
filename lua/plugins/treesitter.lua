return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"apple/pkl-neovim",
		},
		config = function()
			local ensure_installed = {
				"lua",
				"go",
				"templ",
				"rust",
				"javascript",
				"typescript",
				"pkl",
				"gleam",
				"c",
				"cpp",
				"svelte",
				"json",
				"yaml",
				"sql",
				"markdown",
				"html",
				"css",
				"proto",
				"dockerfile",
			}

			local installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(lang)
					return not vim.tbl_contains(installed, lang)
				end)
				:totable()
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
