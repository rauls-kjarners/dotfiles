-- Quality of life plugins
-- nvim-colorizer: color preview in CSS/Tailwind/HTML strings
-- marks.nvim: visualize and manage vim marks (since you'll use them more in nvim)
-- nvim-rip-substitute: better :s UX with live preview

return {
  -- Color swatches inline in the buffer
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        tailwind = true,
        css = true,
        html = true,
      },
    },
  },

  -- Show marks in the sign column + manage them easily
  {
    "chentoast/marks.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- Better :s with live preview (think interactive sed in the buffer)
  {
    "chrisgrieser/nvim-rip-substitute",
    keys = {
      {
        "<leader>rr",
        function() require("rip-substitute").sub() end,
        mode = { "n", "x" },
        desc = "Rip substitute",
      },
    },
  },
}
