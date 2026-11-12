local map = vim.keymap.set

map("i", "jj", "<Esc>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<leader>e", "<cmd>Oil<CR>")
map("n", "<leader>d", vim.diagnostic.open_float)
