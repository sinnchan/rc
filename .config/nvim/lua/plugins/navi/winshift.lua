local cmd = require("util.cmd")
return {
  "sindrets/winshift.nvim",
  keys = {
    { "<C-W>m", cmd "WinShift swap" },
    { "<C-W>M", cmd "WinShift" },
  },
}
