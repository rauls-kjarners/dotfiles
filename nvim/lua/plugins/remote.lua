-- Remote development: develop inside SSH hosts, Docker, or Podman containers
-- Useful on immutable Fedora where you develop in distrobox/toolbox containers
-- On connect, it installs Neovim inside the remote target and syncs your config there
--
-- Usage: <leader>Rc → prompts for target (SSH host, docker container, podman container)
-- On first connect to a new target it bootstraps Neovim automatically

return {
  {
    "amitds1997/remote-nvim.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
    keys = {
      { "<leader>Rc", "<cmd>RemoteStart<cr>", desc = "Remote: connect to target" },
      { "<leader>Rs", "<cmd>RemoteInfo<cr>", desc = "Remote: session info" },
      { "<leader>Rk", "<cmd>RemoteStop<cr>", desc = "Remote: stop session" },
      { "<leader>Rl", "<cmd>RemoteLog<cr>", desc = "Remote: view log" },
    },
  },
}
