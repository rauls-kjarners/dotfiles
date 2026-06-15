-- php-lsp (primary) or intelephense (fallback) + phpactor (refactorings only)

return {
  -- 1. LSP: php-lsp (primary), intelephense (fallback) + phpactor (refactorings, no diagnostics)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local has_phplsp = vim.fn.exepath("php-lsp") ~= ""

      opts.servers = opts.servers or {}

      if has_phplsp then
        -- Disable the LazyVim default intelephense
        opts.servers.intelephense = { enabled = false }

        opts.servers["php-lsp"] = {
          cmd = { "php-lsp" },
          filetypes = { "php" },
          root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
          autostart = true,
        }
      else
        -- intelephense: fallback if php-lsp is not present
        opts.servers.intelephense = opts.servers.intelephense or {}
        opts.servers.intelephense.enabled = true
        opts.servers.intelephense.settings = {
          intelephense = {
            environment = {
              includePaths = {
                "vendor/rector/rector/vendor/rector",
                "var/cache/dev/Symfony/Config",
              },
            },
            files = {
              exclude = {
                "**/.git",
                "**/node_modules",
                "**/vendor/**/{Tests,tests}",
                "**/.history",
                "**/vendor/**/vendor",
                "**/var",
                "**/build",
                "**/public/bundles",
              },
            },
          },
        }
      end

      opts.setup = opts.setup or {}
      opts.setup["php-lsp"] = function(_, server_opts)
        local configs = require("lspconfig.configs")
        if not configs["php-lsp"] then
          configs["php-lsp"] = { default_config = server_opts }
        end
        require("lspconfig")["php-lsp"].setup(server_opts)
        return true
      end

      -- phpactor: managed by Mason, unconditionally register to ensure installation
      opts.servers.phpactor = {
        autostart = true,
        init_options = {
          ["language_server_phpstan.enabled"] = false,
          ["language_server_psalm.enabled"] = false,
          ["php_code_sniffer.enabled"] = false,
          ["language_server_php_cs_fixer.enabled"] = false,
          ["language_server.diagnostics_on_update"] = false,
          ["language_server.diagnostics_on_save"] = false,
          ["language_server.diagnostics_on_open"] = false,
        },
      }

      -- Autocommand to split Code Actions and disable phpactor bloat
      local has_phpactor = vim.fn.exepath("phpactor") ~= ""
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("php_lsp_tweaks", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          -- Cripple phpactor so it doesn't conflict with intelephense/php-lsp
          if client and client.name == "phpactor" then
            client.server_capabilities.completionProvider = false
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.renameProvider = false
            client.server_capabilities.diagnosticProvider = false
            -- Additional capabilities stripped to prevent any double UX with primary LSP
            client.server_capabilities.documentHighlightProvider = false
            client.server_capabilities.documentSymbolProvider = false
            client.server_capabilities.implementationProvider = false
            client.server_capabilities.inlineValueProvider = false
            client.server_capabilities.selectionRangeProvider = false
            client.server_capabilities.signatureHelpProvider = false
            client.server_capabilities.typeDefinitionProvider = false
            client.server_capabilities.workspaceSymbolProvider = false
          end

          -- Disable pull diagnostics for php-lsp to prevent duplicate push/pull diagnostics
          if client and client.name == "php-lsp" then
            client.server_capabilities.diagnosticProvider = false
          end
        end,
      })

      return opts
    end,
  },

  -- 2. Disable default phpcs linter
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.php = {}
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
