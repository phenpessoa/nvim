local ensure_installed = {
	"typescript-language-server",
	"prettier",

	"gopls",
	"gofumpt",
	"golangci-lint",
	"golangci-lint-langserver",
	"golines",
	"gotests",
	"gomodifytags",
	"gci",
	"delve",

	"rust-analyzer",

	"html-lsp",
	"htmx-lsp",
	"tailwindcss-language-server",

	"lua-language-server",
	"stylua",

	"clangd",
	"clang-format",
}

local options = {
	ensure_installed = ensure_installed, -- not an option from mason.nvim

	PATH = "skip",

	ui = {
		icons = {
			package_pending = " ",
			package_installed = "󰄳 ",
			package_uninstalled = " 󰚌",
		},

		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
			cancel_installation = "<C-c>",
		},
	},

	max_concurrent_installers = 10,
}

return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		opts = options,
		config = function(_, opts)
			require("mason").setup(opts)

			vim.api.nvim_create_user_command("MasonInstallAll", function()
				vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
			end, {})

			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},
}
