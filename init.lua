local opt = vim.opt
local set = vim.keymap.set
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
opt.rtp:prepend(lazypath)

vim.filetype.add({ extension = { templ = "templ" } })

set('n', 'y', '"+y', { noremap = true, silent = true })
set('v', 'y', '"+y', { noremap = true, silent = true })

set('n', '<leader>Y', 'gg"+yG', { noremap = true, silent = true })
set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
set('x', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
set('n', '<Esc>', '<cmd> noh <CR>', { noremap = true, silent = true})

set('i', '<C-h>', '<Left>', { noremap = true, silent = true })
set('i', '<C-l>', '<Right>', { noremap = true, silent = true })
set('i', '<C-j>', '<Down>', { noremap = true, silent = true })
set('i', '<C-k>', '<Up>', { noremap = true, silent = true })

set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })

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

g.dap_virtual_text = true

require("lazy").setup("plugins")
