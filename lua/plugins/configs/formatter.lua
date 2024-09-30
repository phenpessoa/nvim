vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	command = "FormatWriteLock",
})

local go_modules_to_ignore = {
	"github.com/toggl/",
	"github.com/a-h/templ",
}

local function get_go_module_name()
	local util = require("lspconfig/util")
	if not util then
		return
	end
	local root_dir = util.root_pattern("go.work", "go.mod", ".git")(vim.fn.getcwd())
	if not root_dir then
		return
	end

	local file = io.open(root_dir .. "/go.mod", "r")
	if file then
		local first_line = file:read()
		file:close()
		return string.sub(first_line, 8)
	end

	return nil
end

local function shouldFormatGo()
	local module_name = get_go_module_name()
	if not module_name then
		return false
	end

	for _, v in pairs(go_modules_to_ignore) do
		if module_name:find(v) then
			return false
		end
	end

	return true
end

local function get_go_formatters()
	local cmds = {}
	if not shouldFormatGo() then
		table.insert(cmds, function()
			return {
				exe = "gofmt",
				args = { "-s", "-w" },
			}
		end)

		table.insert(cmds, function()
			return {
				exe = "goimports",
				args = { "-w" },
			}
		end)
	else
		table.insert(cmds, function()
			return {
				exe = "gofumpt",
				args = { "-l", "-w" },
			}
		end)

		table.insert(cmds, function()
			return {
				exe = "golines",
				args = { "-w", "-m 120" },
			}
		end)
	end

	local util = require("formatter.util")
	local args = {
		"write",
		"-s",
		util.quote_cmd_arg("standard"),
	}

	local module_name = get_go_module_name()
	if module_name then
		table.insert(args, "-s")
		table.insert(args, util.quote_cmd_arg("prefix(" .. module_name .. ")"))
	end

	table.insert(args, "-s")
	table.insert(args, "default")
	table.insert(args, "--custom-order")

	table.insert(cmds, function()
		return {
			exe = "gci",
			args = args,
		}
	end)

	return cmds
end

return {
	filetype = {
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		typescriptreact = {
			require("formatter.filetypes.typescript").prettier,
		},
		html = {
			require("formatter.filetypes.html").prettier,
		},
		css = {
			require("formatter.filetypes.css").prettier,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		c = {
			require("formatter.filetypes.c").clangformat,
		},
		cpp = {
			require("formatter.filetypes.cpp").clangformat,
		},
		go = get_go_formatters(),
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
		templ = {
			function()
				return {
					exe = "templ fmt",
				}
			end,
		},
	},
}
