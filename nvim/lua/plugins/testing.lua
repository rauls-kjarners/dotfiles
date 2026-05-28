-- Testing: neotest with PHPUnit and Pest adapters
-- Extends LazyVim's test.core extra (which provides neotest + UI keymaps)

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-phpunit",
      "theutz/neotest-pest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("neotest-phpunit"),
        require("neotest-pest"),
      })
      return opts
    end,
  },
}
