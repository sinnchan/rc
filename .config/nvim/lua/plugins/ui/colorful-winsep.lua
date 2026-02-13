return {
  "nvim-zh/colorful-winsep.nvim",
  cond = not vim.g.neovide,
  event = { "WinLeave" },
  opts = {
    hi = { bg = "NONE" },
    symbols = { "─", "│", "╭", "╮", "╰", "╯" },
    animate = {
      enabled = not vim.g.performance_mode,
    },
  },
}
