return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  cmd = { "Obsidian" },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "main",
        path = "~/OneDrive/vaults/main",
      },
    },
    daily_notes = {
      folder = "dailies",
    },
    ---@diagnostic disable-next-line: missing-fields
    templates = {
      folder = "templates",
    },
    -- Converts "My Project" to "my-project.md"
    note_id_func = function(title)
      return require("obsidian.builtin").title_id(title)
    end,
    picker = {
      name = "snacks.picker",
      note_mappings = {
        insert_link = "<C-i>",
      },
    },
  },
}
