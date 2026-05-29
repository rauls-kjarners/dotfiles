-- Navigation enhancements
-- glance.nvim: peek definitions/references without leaving current position
-- dropbar.nvim: VS Code / PhpStorm style breadcrumbs in the winbar

return {
  -- Peek definitions, references, implementations in a floating window
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gpd", "<cmd>Glance definitions<cr>",      desc = "Peek: definitions" },
      { "gpr", "<cmd>Glance references<cr>",       desc = "Peek: references" },
      { "gpt", "<cmd>Glance type_definitions<cr>", desc = "Peek: type definitions" },
      { "gpi", "<cmd>Glance implementations<cr>",  desc = "Peek: implementations" },
    },
    opts = {},
  },

  -- Winbar breadcrumbs (class > method > current scope)
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    opts = {
      bar = {
        update_debounce = 100,
      },
    },
  },
}
