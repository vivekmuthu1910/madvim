vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({"i", "n", "v"}, "<C-j>", "<cmd>wincmd j<cr>")
vim.keymap.set({"i", "n", "v"}, "<C-h>", "<cmd>wincmd h<cr>")
vim.keymap.set({"i", "n", "v"}, "<C-k>", "<cmd>wincmd k<cr>")
vim.keymap.set({"i", "n", "v"}, "<C-l>", "<cmd>wincmd l<cr>")
