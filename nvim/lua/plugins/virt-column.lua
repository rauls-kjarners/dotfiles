return {
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = "│",
    },
    config = function(_, opts)
      require("virt-column").setup(opts)
      -- ColorColumn bg cleared by the ColorScheme autocmd in autocmds.lua (more robust)
    end,
  },
}
