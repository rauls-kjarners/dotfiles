-- Database tooling (replaces PhpStorm's DB tool window)
-- vim-dadbod: DB connection engine
-- vim-dadbod-ui: visual schema browser + query runner
-- vim-dadbod-completion: table/column name completion in SQL buffers

return {
  {
    "tpope/vim-dadbod",
    cmd = "DB",
    lazy = true,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<cr>",        desc = "DB: toggle UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "DB: add connection" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
    init = function()
      -- Hook into nvim-cmp if present
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "vim-dadbod-completion" },
            }, {
              { name = "buffer" },
            }),
          })
        end,
      })
    end,
  },
}
