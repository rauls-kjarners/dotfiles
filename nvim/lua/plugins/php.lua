-- PHP language tooling
-- PHPantom (primary LSP) + phpactor (refactorings only) + PHPStan + php-cs-fixer

return {
  -- 1. LSP: PHPantom (primary) + phpactor (refactorings, no diagnostics)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- PHPantom is not in nvim-lspconfig's registry yet; register it manually
      local configs = require("lspconfig.configs")
      if not configs.phpantom then
        configs.phpantom = {
          default_config = {
            cmd = { "phpantom_lsp" },
            filetypes = { "php" },
            root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
            single_file_support = true,
          },
        }
      end

      opts.servers = opts.servers or {}

      -- Disable the LazyVim default
      opts.servers.intelephense = { enabled = false }

      -- PHPantom: only register if binary is in PATH (install from GitHub releases)
      if vim.fn.exepath("phpantom_lsp") ~= "" then
        opts.servers.phpantom = {}
      end

      -- phpactor: only register if binary is in PATH
      -- Install: composer global require phpactor/phpactor
      if vim.fn.exepath("phpactor") ~= "" then
        opts.servers.phpactor = {
          init_options = {
            ["language_server_phpstan.enabled"] = false,
            ["language_server_psalm.enabled"] = false,
            ["language_server.diagnostics_on_update"] = false,
            ["language_server.diagnostics_on_save"] = false,
            ["language_server.diagnostics_on_open"] = false,
          },
        }
      end

      return opts
    end,
  },

  -- 2. PHPStan as diagnostics layer (via nvim-lint)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.php = { "phpstan" }
      return opts
    end,
  },

  -- 3. php-cs-fixer as formatter (via conform)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Falls back to vendor/bin/php-cs-fixer or global install
      opts.formatters_by_ft.php = { "php_cs_fixer" }
      return opts
    end,
  },
}
