local plug = require("util.plug")

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  priority = 100,
  config = function()
    local hooks = plug["ibl.hooks"]
    plug.ibl.setup {
      indent = {
        char = "▏",
        highlight = plug.gradient_gen.indent_color_keys,
      },
      scope = {
        highlight = plug.gradient_gen.indent_color_keys,
        show_start = false,
      },
    }

    hooks.register(
      hooks.type.SCOPE_HIGHLIGHT,
      hooks.builtin.scope_highlight_from_extmark
    )
  end,
}
