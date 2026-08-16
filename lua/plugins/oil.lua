return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			columns = {
				"icon",
				"permissions",
				"size",
				{ "spacer", highlight = "NonText" },
			},
		},
		config = function(_, opts)
			require("oil.columns").register("spacer", {
				render = function()
					return "│"
				end,
				parse = function(line)
					return line:match("^([│]*)%s*(.*)$")
				end,
			})
			require("oil").setup(opts)
		end,
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,
	},
}
