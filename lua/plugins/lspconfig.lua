local function organize_imports()
    local params = {
      command = "_typescript.organizeImports",
      arguments = {vim.api.nvim_buf_get_name(0)},
    }
    vim.lsp.buf.execute_command(params)
end

local map = vim.keymap.set

local function apply(curr, win)
    local newName = vim.trim(vim.fn.getline ".")
    vim.api.nvim_win_close(win, true)

    if #newName > 0 and newName ~= curr then
        local params = vim.lsp.util.make_position_params()
        params.newName = newName

        vim.lsp.buf_request(0, "textDocument/rename", params)
    end
end

local function rename()
    local currName = vim.fn.expand "<cword>" .. " "

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

    vim.cmd "normal A"
    vim.cmd "startinsert"

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
                capabilities = capabilities,
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
                capabilities = capabilities,
                cmd = {"gopls"},
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					env = {
						GOEXPERIMENT = "rangefunc",
					},
                    formatting = {
                        gofumpt = true,
                    },
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                            useany = true,
                        },
                        gofumpt = true,
                        staticcheck = true,
                    },
                    lintOnSave = "workspace",
                    vetOnSave = "workspace",
                    buildOnSave = "workspace",
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
                settings = {
                    tailwindCSS = {
                        includeLanguages = {
                            templ = "html",
                        },
                    },
                },
            })

		end,
	},
}
