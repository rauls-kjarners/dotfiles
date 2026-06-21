return {
  {
    "carderne/pi-nvim",
    event = "VeryLazy",
    config = function()
      require("pi-nvim").setup({
        set_default_keymaps = false,
      })
      vim.keymap.set({ "n", "v" }, "<leader>ap", ":Pi<CR>", { desc = "Send to Pi (OMP)" })
      vim.keymap.set("n", "<leader>aP", ":PiSendBuffer<CR>", { desc = "Send Buffer to Pi (OMP)" })
    end,
  },
}
