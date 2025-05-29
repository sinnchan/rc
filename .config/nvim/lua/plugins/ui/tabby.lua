local plug = require("util.plug")

return {
  "nanozuki/tabby.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    theme = {
      fill = "TabLineFill",
      head = "TabLine",
      current_tab = "TabLineSel",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
    },
    nerdfont = true,
    lualine_theme = "onedark",
    buf_name = { mode = "unique" },
  },
  config = function(_, opts)
    plug["tabby.tabline"].use_preset("tab_only", opts)
  end,
}
