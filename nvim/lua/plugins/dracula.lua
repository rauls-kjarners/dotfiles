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
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
