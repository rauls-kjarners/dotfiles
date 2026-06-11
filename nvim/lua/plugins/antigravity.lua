return {
  {
    "NakLast/antigravity-cli.nvim",
    keys = {
      { "<leader>ag", "<cmd>Antigravity<cr>", desc = "Toggle Antigravity" },
    },
    config = function()
      require("antigravity").setup({
        cmd = "agy"
      })
    end,
  },
}
