return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>db",
				"<cmd> DapToggleBreakpoint <CR>",
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dc",
				"<cmd> DapContinue <CR>",
				desc = "Dap continue",
			},
			{
				"<leader>ds",
				"<cmd> DapStepInto <CR>",
				desc = "Dap step into",
			},
			{
				"<leader>do",
				"<cmd> DapStepOut <CR>",
				desc = "Dap step out",
			},
			{
				"<leader>dn",
				"<cmd> DapStepOver <CR>",
				desc = "Dap step over",
			},
			{
				"<leader>dh",
				function()
					local dap = require("dap")
					local dap_sessions = dap.sessions()

					for _, session in pairs(dap_sessions) do
						if session.filetype == "go" then
							vim.api.nvim_command("GoDbgStop")
						end
					end

					if next(dap_sessions) then
						vim.api.nvim_command("DapStop")
					end
				end,
				desc = "Terminate debug session",
			},
			{
				"<leader>dus",
				function()
					local widgets = require("dap.ui.widgets")
					local sidebar = widgets.sidebar(widgets.scopes)
					sidebar.open()
				end,
				desc = "Open debugging sidebar",
			},
			{
				"<leader>dw",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear all breakpoints",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		init = function()
			require("dapui").setup()
		end,
		keys = {
			{
				"<leader>dt",
				function()
					local dapui = require("dapui")
					dapui.toggle()
				end,
				desc = "Toggle dapui",
			},
			{
				"<leader>dr",
				function()
					local dapui = require("dapui")
					dapui.open({ reset = true })
				end,
				desc = "Reset dapui",
			},
			{
				"<leader>dT",
				function()
					local render = require("dapui.config").render
					render.max_type_length = (render.max_type_length == nil) and 0 or nil
					require("dapui").update_render(render)
				end,
				desc = "Toggle types on dapui locals",
			},
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = false,
		config = function(_, opts)
			require("nvim-dap-virtual-text").setup()
		end,
	},
}
