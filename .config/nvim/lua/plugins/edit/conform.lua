return {
  'stevearc/conform.nvim',
  ft = { "gdscript" },
  opts = {
    formatters_by_ft = {
      gdscript = { "gdformat", lsp_format = "fallback" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
  },
}
