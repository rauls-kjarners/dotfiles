return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "jaljoue/dracula-alucard.nvim",
    lazy = true, -- loaded on demand by auto-dark-mode when switching to light
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        pcall(vim.cmd, "colorscheme dracula")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        pcall(vim.cmd, "colorscheme dracula-alucard")

        -- Fix Neotest contrast for Alucard (Light Mode)
        -- Using official Alucard palette colors for perfect visual integration
        vim.schedule(function()
          vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#14710A", bold = true }) -- Alucard green
          vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#CB3A2A", bold = true }) -- Alucard red
          vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#A34D14", bold = true }) -- Alucard orange
          vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#036A96", bold = true }) -- Alucard cyan
          vim.api.nvim_set_hl(0, "NeotestDir", { fg = "#644AC9", bold = true }) -- Alucard purple
          vim.api.nvim_set_hl(0, "NeotestFile", { fg = "#1F1F1F", bold = true }) -- Alucard fg
          vim.api.nvim_set_hl(0, "NeotestNamespace", { fg = "#A3144D", bold = true }) -- Alucard pink
          vim.api.nvim_set_hl(0, "NeotestAdapterName", { fg = "#CB3A2A", bold = true }) -- Alucard red
          vim.api.nvim_set_hl(0, "NeotestIndent", { fg = "#6C664B" }) -- Alucard comment
          vim.api.nvim_set_hl(0, "NeotestExpandMarker", { fg = "#9B9278" }) -- Alucard gutter_fg
        end)
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts = type(opts) == "table" and opts or {}
      opts.colorscheme = vim.env.BAT_THEME == "Alucard" and "dracula-alucard" or "dracula"
      return opts
    end,
  },
}
