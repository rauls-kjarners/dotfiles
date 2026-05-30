-- Python language tooling
-- LSP: basedpyright (set in options.lua) + ruff (both wired by lang.python extra)
-- Formatter/linter: ruff (extra default) — no overrides needed
-- Debugging: debugpy via dap.core + lang.python extra
-- Testing: neotest-python via test.core + lang.python extra

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Tame basedpyright's aggressive default type-checking (off → basic → standard → strict).
      -- "standard" catches real errors (missing types, bad calls, unresolved imports) without
      -- drowning Django/FastAPI/AI-SDK codebases in noise. Good fit for typed web + AI work.
      opts.servers.basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "recommended",
            },
          },
        },
      }

      return opts
    end,
  },
}
