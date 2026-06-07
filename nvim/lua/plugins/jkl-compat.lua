return {

  -- Telescope override (jkl; navigation scheme: k=down, l=up)
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

  -- Snacks picker override (snacks is the default LazyVim picker; needs the same remaps)
  -- Default snacks: C-k=list_up, j=list_down in list, C-n/C-p still work and are kept.
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              -- k=down, l=up to match jkl; movement scheme; disable j (= left in scheme)
              ["<C-j>"] = false,
              ["<C-k>"] = { "list_down", mode = { "i", "n" } },
              ["<C-l>"] = { "list_up",   mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              -- Disable j (list_down by default, but j=left in global scheme)
              ["j"] = false,
              ["k"] = "list_down",
              ["l"] = "list_up",
            },
          },
        },
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["l"] = "list_up",
                  ["k"] = "list_down",
                  ["j"] = "explorer_close",
                  [";"] = "confirm",
                  ["h"] = false,
                }
              }
            }
          }
        }
      },
    },
  },

  -- Neo-tree override (jkl; navigation scheme: j=left/close, k=down, l=up/none, ;=right/open)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["l"] = "none",          -- Fall back to global k (Move Up)
          ["k"] = "none",          -- Fall back to global j (Move Down)
          ["j"] = "close_node",    -- Explicit Neo-tree command for Left
          [";"] = "open",          -- Explicit Neo-tree command for Right
          ["h"] = "none",          -- Clear LazyVim's default close_node mapping on h
        },
      },
    },
  },
}
