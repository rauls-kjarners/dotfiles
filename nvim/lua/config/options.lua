-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Python LSP selection (must be set before lazy.nvim loads lang.python extra)
vim.g.lazyvim_python_lsp = "basedpyright"

-- Persistent undo (required for undotree cross-session history)
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.opt.wrap = false
vim.opt.colorcolumn = "120"

-- Disable whole line highlight (reduces noise and fixes color conflict with ColorColumn)
vim.opt.cursorline = false

-- Hide the tab/buffer line at the top
vim.opt.showtabline = 0
