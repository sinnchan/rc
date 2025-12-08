return {
  'stevearc/conform.nvim',
  ft = { "gdscript" },
  opts = {
    default_format_opts = {
      lsp_format = "prefer",
    },
    formatters_by_ft = {
      gdscript = { "gdformat", lsp_format = "fallback" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
  },
}
