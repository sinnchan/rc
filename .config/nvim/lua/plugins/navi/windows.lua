local plug = require("util.plug")
local cmd = require("util.cmd")

return {
  "anuvyklack/windows.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  config = function()
    vim.o.winwidth = 10
    vim.o.winminwidth = 10
    vim.o.equalalways = false
    plug.windows.setup()
  end,
  keys = {
    { "<C-w>z", cmd "WindowsMaximize" },
    { "<C-w>_", cmd "WindowsMaximizeVertically" },
    { "<C-w>|", cmd "WindowsMaximizeHorizontally" },
    { "<C-w>=", cmd "WindowsEqualize" },
  },
}
