return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "markdown-oxide" })
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable marksman (installed by LazyVim's default markdown extra)
        marksman = false,
        markdown_oxide = {
          -- 1. Wipe out the legacy lspconfig function so Neovim 0.12 handles it natively
          root_dir = false,
          -- 2. Define the exact markers to search for (NO .git!)
          root_markers = { ".moxide.toml", ".obsidian" },
          -- 3. Tell Neovim 0.12: "If you don't find these markers, abort!"
          workspace_required = true,
          
          capabilities = {
            workspace = {
              didChangeWatchedFiles = { dynamicRegistration = true },
            },
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
  },
}
