return {
  "nvim-zh/colorful-winsep.nvim",
  cond = not vim.g.neovide,
  event = { "WinLeave" },
  opts = {
    hi = { bg = "background" },
    symbols = { "─", "│", "╭", "╮", "╰", "╯" },
  },
}
