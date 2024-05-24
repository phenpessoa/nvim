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
vim.o.t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"
vim.o.t_8b = "\\<Esc>[48;2;%lu;%lum"
