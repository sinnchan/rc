local cmd = require("util.cmd")
return {
  "johmsalas/text-case.nvim",
  opts = {
    pickers = {
      find_files = { follow = true }
    }
  },
  keys = { { "<leader>fC", cmd "TextCaseOpenTelescope" } },
}
