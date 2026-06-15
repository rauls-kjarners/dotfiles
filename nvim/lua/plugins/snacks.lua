return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true }, -- <leader>e (File Explorer)
          files = { hidden = true },    -- <leader>ff (Find Files)
          smart = { hidden = true },    -- <leader><space> (Smart Find Files)
        },
      },
    },
  },
}
