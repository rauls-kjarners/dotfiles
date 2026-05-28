-- Git tooling (complements LazyVim's gitsigns + lazygit)
-- diffview.nvim: proper 3-way merge UI and file history (closest to PhpStorm's merge tool)
-- neogit: magit-style interactive git UI

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>",  desc = "Git: diff view" },
      { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Git: close diff view" },
      { "<leader>gx", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: file history" },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      { "<leader>gN", "<cmd>Neogit<cr>", desc = "Git: Neogit" },
    },
  },
}
