local plug = require("util.plug")

return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  main = "lsp_lines",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>lt", function() plug.lsp_lines.toggle() end },
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
    })
    plug.lsp_lines.setup()
  end,
}
