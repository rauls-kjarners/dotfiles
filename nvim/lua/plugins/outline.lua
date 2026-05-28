-- Symbol outline + call hierarchy
-- outline.nvim: rich symbol tree (supplement to aerial which LazyVim already provides)
-- trouble.nvim: call hierarchy views (incoming/outgoing calls)

return {


  -- Call hierarchy via trouble.nvim (PhpStorm's "Call Hierarchy" tool window)
  {
    "folke/trouble.nvim",
    optional = true,
    keys = {
      { "<leader>ci", "<cmd>Trouble lsp_incoming_calls toggle<cr>", desc = "Incoming calls" },
      { "<leader>cO", "<cmd>Trouble lsp_outgoing_calls toggle<cr>", desc = "Outgoing calls" },
    },
  },
}
