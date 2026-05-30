return {

  -- Telescope override
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = false,
              ["<C-k>"] = actions.move_selection_next,
              ["<C-l>"] = actions.move_selection_previous,
            },
            n = {
              ["j"] = false,
              ["k"] = actions.move_selection_next,
              ["l"] = actions.move_selection_previous,
            },
          },
        },
      }
    end,
  },
}
