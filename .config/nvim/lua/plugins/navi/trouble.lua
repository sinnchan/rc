local cmd = require("util.cmd")

return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xx", cmd "Trouble diagnostics toggle filter.buf=0" },
    { "<leader>xX", cmd "Trouble diagnostics toggle" },
  },
}
