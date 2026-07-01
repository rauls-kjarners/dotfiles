return {
  "tris203/precognition.nvim",
  opts = {
    startVisible = false,
    hints = {
      h = { prio = 0 },
      j = { prio = 0 },
      k = { prio = 0 },
      l = { prio = 0 },
      [";"] = { prio = 0 },
    },
  },
  keys = {
    { "<leader>uP", function() require("precognition").toggle() end, desc = "Toggle Precognition" },
  },
}
