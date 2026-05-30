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

      local has_phpantom = vim.fn.exepath("phpantom_lsp") ~= ""
      local has_phplsp = vim.fn.exepath("php-lsp") ~= ""

      -- PHPantom: highest priority
      if has_phpantom then
        opts.servers.phpantom = {}
      end

      -- php-lsp: register but only autostart if phpantom is missing
      if has_phplsp then
        opts.servers["php-lsp"] = {
          autostart = not has_phpantom,
        }
      end

      -- phpactor: only register if binary is in PATH
      if vim.fn.exepath("phpactor") ~= "" then
        local is_fallback = not has_phpantom and not has_phplsp
        opts.servers.phpactor = {
          autostart = true,
          init_options = is_fallback and {} or {
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
