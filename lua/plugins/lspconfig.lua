local function organize_imports()
    local params = {
      command = "_typescript.organizeImports",
      arguments = {vim.api.nvim_buf_get_name(0)},
    }
    vim.lsp.buf.execute_command(params)
end

local function dorename(win)
  local new_name = vim.trim(vim.fn.getline('.'))
  vim.api.nvim_win_close(win, true)
  vim.lsp.buf.rename(new_name)
end

local function rename()
  local opts = {
    relative = 'cursor',
    row = 0,
    col = 0,
    width = 30,
    height = 1,
    style = 'minimal',
    border = 'single'
  }
  local cword = vim.fn.expand('<cword>')
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  local fmt =  '<cmd>lua Rename.dorename(%d)<CR>'

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cword})
  vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', string.format(fmt, win), {silent=true})
end

_G.Rename = {
   rename = rename,
   dorename = dorename
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
                    vim.lsp.buf.implementation()
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
            }
        },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            local util = require "lspconfig/util"

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
							disable = { "different-requires" },
						},
					},
				},
			})

			lspconfig.gopls.setup({
                cmd = {"gopls"},
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					env = {
						GOEXPERIMENT = "rangefunc",
					},
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                    },
                    gofumpt = true,
                    staticcheck = true,
                    gopls = {
                        ["ui.inlayhint.hints"] = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
				},
			})

            lspconfig.templ.setup({
                capabilities = capabilities,
                filetypes = { "templ" },
            })

            lspconfig.tsserver.setup {
                capabilities = capabilities,
                init_options = {
                    preferences = {
                        disableSuggestions = true,
                    },
                },
                commands = {
                    OrganizeImports = {
                        organize_imports,
                        description = "Organize Imports",
                    }
                },
            }

            lspconfig.html.setup({
                capabilities = capabilities,
                filetypes = { "html", "templ" },
            })

            lspconfig.htmx.setup({
                capabilities = capabilities,
                filetypes = { "html", "templ" },
            })

            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                filetypes = { "templ", "astro", "javascript", "typescript", "react" },
                init_options = { userLanguages = { templ = "html" } },
            })

		end,
	},
}
