return {
  { "akinsho/bufferline.nvim", enabled = false },
  
  -- Disable LSP inlay hints globally
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
