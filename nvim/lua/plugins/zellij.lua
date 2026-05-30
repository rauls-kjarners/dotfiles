return {
  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<A-j>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "Navigate left (Zellij/Neovim)" } },
      { "<A-k>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "Navigate down (Zellij/Neovim)" } },
      { "<A-l>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "Navigate up (Zellij/Neovim)" } },
      { "<A-;>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "Navigate right (Zellij/Neovim)" } },
    },
    opts = {},
  },
}
