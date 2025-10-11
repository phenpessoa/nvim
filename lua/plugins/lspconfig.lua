local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.lsp.buf.execute_command(params)
end

local map = vim.keymap.set

local function apply(curr, win)
	local newName = vim.trim(vim.fn.getline("."))
	vim.api.nvim_win_close(win, true)

	if #newName > 0 and newName ~= curr then
		local params = vim.lsp.util.make_position_params()
		params.newName = newName

		vim.lsp.buf_request(0, "textDocument/rename", params)
	end
end

local function rename()
	local currName = vim.fn.expand("<cword>") .. " "

	local win = require("plenary.popup").create(currName, {
		title = "Renamer",
		style = "minimal",
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		relative = "cursor",
		borderhighlight = "RenamerBorder",
		titlehighlight = "RenamerTitle",
		focusable = true,
		width = 25,
		height = 1,
		line = "cursor+2",
		col = "cursor-1",
	})

	vim.cmd("normal A")
	vim.cmd("startinsert")

	map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

	map({ "i", "n" }, "<CR>", function()
		apply(currName, win)
		vim.cmd.stopinsert()
	end, { buffer = 0 })
end

_G.Rename = {
	rename = rename,
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"williamboman/mason.nvim",
		},
		lazy = false,
		keys = {
			{
				"gD",
				function()
					vim.lsp.buf.declaration()
				end,
				desc = "LSP Declaration",
			},
			{
				"gd",
				function()
					vim.lsp.buf.definition()
				end,
				desc = "LSP Definition",
			},
			{
				"K",
				function()
					vim.lsp.buf.hover()
				end,
				desc = "LSP Hover",
			},
			{
				"gi",
				function()
					require("telescope.builtin").lsp_implementations()
				end,
				desc = "LSP implementation",
			},
			{
				"<leader>ca",
				function()
					vim.lsp.buf.code_action()
				end,
				desc = "LSP code action",
			},
			{
				"gr",
				function()
					require("telescope.builtin").lsp_references()
				end,
				desc = "LSP references",
			},
			{
				"<leader>ra",
				"<cmd>lua Rename.rename()<CR>",
				desc = "LSP rename",
			},
			{
				"<leader>h",
				function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end,
				desc = "Enable inlay hints",
			},
		},
		config = function()
			local util = require("lspconfig/util")

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
							disable = { "different-requires" },
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("gopls", {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					env = {
						GOEXPERIMENT = "rangefunc",
					},
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
							useany = true,
						},
						staticcheck = true,
					},
					lintOnSave = "workspace",
					vetOnSave = "workspace",
					buildOnSave = "workspace",
				},
			})
			vim.lsp.enable("gopls")

			vim.lsp.config("templ", {
				filetypes = { "templ" },
			})
			vim.lsp.enable("templ")

			vim.lsp.config("clangd", {
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },
			})
			vim.lsp.enable("clangd")

			vim.lsp.config("ts_ls", {
				init_options = {
					preferences = {
						disableSuggestions = true,
					},
				},
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})
			vim.lsp.enable("ts_ls")

			vim.lsp.config("html", {
				filetypes = { "html", "templ" },
			})
			vim.lsp.enable("html")

			vim.lsp.config("htmx", {
				filetypes = { "html", "templ" },
			})
			vim.lsp.enable("htmx")

			vim.lsp.config("tailwindcss", {
				filetypes = { "templ", "astro", "javascript", "typescript", "react", "typescriptreact" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			})
			vim.lsp.enable("tailwindcss")

			vim.lsp.config("golangci_lint_ls", {
				filetypes = { "go", "gomod" },
				root_dir = util.root_pattern(".git", "go.mod"),
				init_options = {
					command = {
						"golangci-lint",
						"run",
						"--output.text.path",
						"/dev/null",
						"--output.json.path",
						"stdout",
						"--issues-exit-code=1",
						"--show-stats=false",
					},
				},
			})

			vim.lsp.config("intelephense", {
				filetypes = { "php" },
			})
			vim.lsp.enable("intelephense")

			vim.lsp.config("protols", {
				filetypes = { "proto" },
			})
			vim.lsp.enable("protols")

			vim.lsp.config("svelte", {
				filetypes = { "svelte" },
				settings = {
					svelte = {
						plugin = {
							svelte = {
								defaultScriptLanguage = "ts",
							},
						},
					},
				},
			})
			vim.lsp.enable("svelte")
		end,
	},
}
