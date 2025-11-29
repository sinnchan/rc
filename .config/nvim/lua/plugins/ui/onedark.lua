local plug = require("util.plug")
local colors = require("util.colors_gen")

return {
  "navarasu/onedark.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    transparent = true,
    style = "darker",
    colors = {
      search = "#FFFF00",
    },
    highlights = {
      ["Search"] = { fg = "$search", bg = "NONE", underline = true },
      ["IncSearch"] = { fg = "$search", bg = "NONE", underline = true },
      ["CurSearch"] = { fg = "black", bg = "$search" },
    }
  },
  config = function(_, opts)
    plug.onedark.setup(opts)
    plug.onedark.load()
    colors.setup()
    colors.apply()
  end,
}
