local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.filetype.add({ extension = { templ = "templ" } })
g.dap_virtual_text = true

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		require("nvim-treesitter.parsers").blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				branch = "main",
			},
		}
	end,
})

vim.api.nvim_create_augroup("BladeFiletypeRelated", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = "BladeFiletypeRelated",
	pattern = "*.blade.php",
	callback = function()
		vim.bo.filetype = "blade"
	end,
})
