local cmd = require("util.cmd")
return {
  "LintaoAmons/scratch.nvim",
  cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
  keys = { { "<leader>fs", cmd "ScratchOpenFzf" } },
  opts = { filetypes = { "txt", "md", "sh", "lua", "py" } },
}
