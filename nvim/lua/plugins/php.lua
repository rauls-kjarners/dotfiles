-- PHP language tooling
-- PHPantom (primary LSP) + phpactor (refactorings only) + PHPStan + php-cs-fixer

return {
  -- 1. LSP: PHPantom (primary) + phpactor (refactorings, no diagnostics)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local has_phpantom = vim.fn.exepath("phpantom_lsp") ~= ""
      local has_phplsp = vim.fn.exepath("php-lsp") ~= ""

      opts.servers = opts.servers or {}

      -- Disable the LazyVim default
      opts.servers.intelephense = { enabled = false }

      -- PHPantom: highest priority
      if has_phpantom then
        opts.servers.phpantom = {
          cmd = { "phpantom_lsp", "--stdio" },
          filetypes = { "php" },
          root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
          single_file_support = true,
        }
      end

      -- php-lsp: register but only autostart if phpantom is missing
      if has_phplsp then
        opts.servers["php-lsp"] = {
          cmd = { "php-lsp" },
          filetypes = { "php" },
          root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
          autostart = not has_phpantom,
        }
      end

      opts.setup = opts.setup or {}
      local function register_custom_lsp(name)
        opts.setup[name] = function(_, server_opts)
          local configs = require("lspconfig.configs")
          if not configs[name] then
            configs[name] = { default_config = server_opts }
          end
          require("lspconfig")[name].setup(server_opts)
          return true
        end
      end
      register_custom_lsp("phpantom")
      register_custom_lsp("php-lsp")

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

      -- Autocommand to split Code Actions and disable phpactor bloat
      local strip_phpactor = has_phpantom or has_phplsp
      local has_phpactor = vim.fn.exepath("phpactor") ~= ""
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("php_lsp_tweaks", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          -- Only cripple phpactor when a primary LSP is present; in fallback mode it's the sole server
          if client and client.name == "phpactor" and strip_phpactor then
            client.server_capabilities.completionProvider = false
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.renameProvider = false
          end

          if vim.bo[bufnr].filetype == "php" then
            -- Buffer-local maps beat global ones; no defer needed
            vim.keymap.set({ "n", "v" }, "<leader>ca", function()
              vim.lsp.buf.code_action({
                filter = function(_, cid)
                  local c = vim.lsp.get_client_by_id(cid)
                  return c and c.name ~= "phpactor"
                end
              })
            end, { buffer = bufnr, desc = "Code Action (Fast)" })

            -- <leader>cp = phpactor refactorings only; only bind when phpactor is installed
            if has_phpactor and strip_phpactor then
              vim.keymap.set({ "n", "v" }, "<leader>cp", function()
                vim.lsp.buf.code_action({
                  filter = function(_, cid)
                    local c = vim.lsp.get_client_by_id(cid)
                    return c and c.name == "phpactor"
                  end
                })
              end, { buffer = bufnr, desc = "Refactor (phpactor)" })
            end
          end
        end,
      })

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
