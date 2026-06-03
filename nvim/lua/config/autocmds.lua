-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Make base statusline transparent so Lualine floats perfectly
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Clear ColorColumn background so virt-column.nvim draws a clean vertical line instead of a block
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "NONE" })
    -- Link the virtual column line to the window separator color so it looks consistent and subtle
    vim.api.nvim_set_hl(0, "VirtColumn", { link = "WinSeparator" })
    -- Clear WinBar background so dropbar.nvim blends into the normal background instead of being pitch black
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
  end,
})

-- Disable conceal for markdown by default (prevents jumping text)
-- You can still toggle conceal manually via <leader>uc
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Aggressive Auto-Reload: Check for file changes when you stop typing or enter buffer
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" }, {
  desc = "Aggressively check for file changes outside of Neovim",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Safe Auto-Save: Saves only when you click out of Neovim or switch files
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  desc = "Auto Save on focus lost and buffer leave",
  callback = function()
    -- Only save if the buffer has been modified, isn't read-only, and is a real file
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.cmd("silent! update")
    end
  end,
})
