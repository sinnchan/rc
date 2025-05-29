return {
  "folke/neodev.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    library = {
      plugins = { "nvim-dap-ui" },
      types = true,
    },
  },
}
