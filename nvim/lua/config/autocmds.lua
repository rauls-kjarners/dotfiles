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
    -- Clear WinBar background so dropbar.nvim blends into the normal background instead of being pitch black
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
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

-- Auto-start a project-specific socket for the AI agent (nvim-mcp --connect auto target)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
local socket_path = '/tmp/nvim-' .. project_name .. '.sock'

-- A crashed session can leave a stale socket file; serverstart would then fail silently.
-- Probe it: if a live nvim answers, leave it alone; otherwise unlink the stale file first.
if vim.loop.fs_stat(socket_path) then
  local ok, chan = pcall(vim.fn.sockconnect, 'pipe', socket_path, { rpc = true })
  if ok and chan ~= 0 then
    vim.fn.chanclose(chan) -- another live instance owns this name; don't steal it
    socket_path = nil
  else
    pcall(vim.loop.fs_unlink, socket_path) -- stale leftover; remove so the path is reusable
  end
end

if socket_path then
  pcall(vim.fn.serverstart, socket_path)
end

-- nvim-mcp plugin creates a pid-named socket for `--connect auto` discovery but never removes it
-- on exit, and its server has no connect timeout — so an orphan socket from a crashed/hung nvim
-- can stall auto-connect before it reaches the live instance.
-- VimLeavePre: remove our own nvim-mcp socket cleanly on normal quit.
vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Remove nvim-mcp discovery socket on exit (plugin leaks it)',
  callback = function()
    for _, addr in ipairs(vim.fn.serverlist()) do
      if addr:match('nvim%-mcp%.') then
        pcall(vim.fn.serverstop, addr)
        pcall(vim.loop.fs_unlink, addr)
      end
    end
  end,
})

-- Startup: prune orphaned nvim-mcp sockets for this project whose owning process is already dead.
local sock_dir = vim.env.XDG_RUNTIME_DIR or vim.env.TMPDIR or '/tmp'
local escaped = (vim.fs.root(0, '.git') or vim.fn.getcwd()):gsub('/', '%%')
for _, f in ipairs(vim.fn.glob(sock_dir .. '/nvim-mcp.' .. escaped .. '.*', false, true)) do
  local pid = tonumber(f:match('(%d+)%.sock$') or f:match('(%d+)$'))
  if pid and not pcall(vim.loop.kill, pid, 0) then
    pcall(vim.loop.fs_unlink, f)
  end
end
