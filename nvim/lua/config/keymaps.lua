-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Ergonomic Movement
map({'n', 'v', 'o'}, 'j', 'h', { desc = 'Move Left' })
map({'n', 'v', 'o'}, 'k', 'j', { desc = 'Move Down' })
map({'n', 'v', 'o'}, 'l', 'k', { desc = 'Move Up' })
map({'n', 'v', 'o'}, ';', 'l', { desc = 'Move Right' })

-- Re-map repeat search
map({'n', 'v', 'o'}, "'", ';', { desc = 'Repeat Search' })

-- Window navigation
map("n", "<C-j>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-k>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-l>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-;>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Buffer navigation (<S-l>=prev, <S-k>=next; replaces LazyVim defaults <S-h>/<S-l>)
pcall(vim.keymap.del, "n", "<S-h>")
pcall(vim.keymap.del, "n", "<S-l>")
map("n", "<S-l>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
map("n", "<S-k>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Terminal window navigation
map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-k>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-l>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-;>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
pcall(vim.keymap.del, "t", "<C-h>")
