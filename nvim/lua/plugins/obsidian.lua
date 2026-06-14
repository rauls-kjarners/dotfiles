return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.resolve(vim.fn.expand("~") .. "/OneDrive/vaults/main") .. "/*.md",
    "BufNewFile " .. vim.fn.resolve(vim.fn.expand("~") .. "/OneDrive/vaults/main") .. "/*.md",
  },
  cmd = { "Obsidian" },
  init = function()
    -- Strip completion from obsidian-ls so markdown-oxide owns completion.
    -- obsidian.nvim always starts obsidian-ls unconditionally (no config opt to disable).
    -- blink.cmp checks completionProvider live per request, so this strip is reliable.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.name == "obsidian-ls" and vim.bo[ev.buf].filetype == "markdown" then
          client.server_capabilities.completionProvider = nil
        end
      end,
    })
  end,
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = { enable = false }, -- Let render-markdown.nvim handle all visual rendering
    legacy_commands = false,
    workspaces = {
      {
        name = "main",
        path = "~/OneDrive/vaults/main",
      },
    },
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d", -- matches moxide.toml dailynote format
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
