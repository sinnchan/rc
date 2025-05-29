local plug = require("util.plug")
return {

  "dstein64/nvim-scrollview",
  event = { "BufReadPre", "BufNewFile" },
  main = "scrollview",
  opts = {
    current_only = true,
    search_symbol = "-",
    signs_on_startup = {
      "changelist", "conflicts", "diagnostics", "folds",
      "marks", "quickfix", "search", "trail",
    },
  },
  config = function(_, opts)
    plug.scrollview.setup(opts)
    plug["scrollview.contrib.gitsigns"].setup(opts)
    vim.api.nvim_set_hl(0, "ScrollViewSearch", { link = "Search" })
  end
}
