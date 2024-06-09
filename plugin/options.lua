local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.colorcolumn = "120"
opt.scrolloff = 8
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.clipboard:append('unnamedplus')
opt.termguicolors = true
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel=999

local g = vim.g
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
