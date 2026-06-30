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

-- Terminal window navigation (Enforced buffer-locally to prevent interception)
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-nav", { clear = true }),
  callback = function()
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>h", { buffer = 0, desc = "Go to Left Window" })
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>j", { buffer = 0, desc = "Go to Lower Window" })
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>k", { buffer = 0, desc = "Go to Upper Window" })
    vim.keymap.set("t", "<C-;>", "<C-\\><C-n><C-w>l", { buffer = 0, desc = "Go to Right Window" })
  end,
})
pcall(vim.keymap.del, "t", "<C-h>")

