local function create_react_component()
	local filename = vim.fn.expand("%:t:r") -- %:t:r removes the file extension
	local template = "export default function " .. filename .. "() {}"
	vim.api.nvim_put({ template }, "l", true, true)
end

vim.api.nvim_create_user_command("ReactCreateComponent", create_react_component, {})
vim.keymap.set(
	"n",
	"<leader>crc",
	"<CMD>ReactCreateComponent<CR>",
	{ desc = "Writes the boilerplate for a react component" }
)
