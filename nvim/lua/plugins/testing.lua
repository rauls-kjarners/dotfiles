-- Testing: neotest with PHPUnit and Pest adapters
-- Extends LazyVim's test.core extra (which provides neotest + UI keymaps)

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-phpunit",
      "theutz/neotest-pest",
    },
    keys = {
      { "<leader>tF", function() require("neotest").run.run({status = "failed"}) end, desc = "Run Failed Tests (Neotest)" },
      { "<leader>tp", function()
          vim.ui.input({ prompt = "Number of paratest processes: ", default = tostring(vim.g.paratest_processes or 6) }, function(input)
            if input and tonumber(input) then
              vim.g.paratest_processes = tonumber(input)
              vim.notify("Paratest processes set to " .. input)
            end
          end)
        end, desc = "Set Paratest Processes" },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("neotest-phpunit")({
          phpunit_cmd = function()
            if vim.fn.filereadable("vendor/bin/paratest") == 1 then
              local processes = vim.g.paratest_processes or 6
              return "vendor/bin/paratest --processes=" .. processes
            end
            return "vendor/bin/phpunit"
          end,
        }),
        require("neotest-pest"),
      })
      return opts
    end,
  },
}
