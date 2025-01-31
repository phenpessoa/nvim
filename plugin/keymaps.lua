local set = vim.keymap.set

-- yank to clipboard as well
set("n", "y", '"+y', { noremap = true, silent = true })
set("v", "y", '"+y', { noremap = true, silent = true })

set("n", "<leader>Y", "<cmd> %y <CR>", { noremap = true, silent = true })
set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
set("x", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
set("n", "<Esc>", "<cmd> noh <CR>", { noremap = true, silent = true })
set("n", "<leader>to", function()
	vim.opt.scrolloff = 999 - vim.o.scrolloff
end)

-- navigate in insert mode
set("i", "<C-h>", "<Left>", { noremap = true, silent = true })
set("i", "<C-l>", "<Right>", { noremap = true, silent = true })
set("i", "<C-j>", "<Down>", { noremap = true, silent = true })
set("i", "<C-k>", "<Up>", { noremap = true, silent = true })

-- navigate through splits
set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

set("n", "<C-e>", function()
	vim.diagnostic.open_float()
end, { noremap = true, silent = true })
set("i", "<C-e>", function()
	vim.diagnostic.open_float()
end, { noremap = true, silent = true })
set("n", "<C-s>", function()
	vim.lsp.buf.signature_help()
end, { noremap = true, silent = true })
set("i", "<C-s>", function()
	vim.lsp.buf.signature_help()
end, { noremap = true, silent = true })

set("v", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { noremap = true, silent = true })

vim.api.nvim_set_keymap("x", "<leader>qw", 'c""<Esc>P', { noremap = true, silent = true })
