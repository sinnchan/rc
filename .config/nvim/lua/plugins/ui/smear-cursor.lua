return {
  "sphamba/smear-cursor.nvim",
  cond = not vim.g.performance_mode and not vim.g.neovide,
  event = "VeryLazy",
  opts = {
    legacy_computing_symbols_support = false,
  },
}
