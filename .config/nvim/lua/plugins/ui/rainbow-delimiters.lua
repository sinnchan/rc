local plug = require("util.plug")

return {
  "hiphish/rainbow-delimiters.nvim",
  event = { "BufReadPre", "BufNewFile" },
  priority = 110,
  config = function()
    vim.g.rainbow_delimiters = {
      strategy = { [""] = plug["rainbow-delimiters"].strategy["global"] },
      query = { [""] = "rainbow-delimiters" },
      priority = { [""] = 110 },
      highlight = plug.gradient_gen.scope_color_keys,

    }
  end
}
