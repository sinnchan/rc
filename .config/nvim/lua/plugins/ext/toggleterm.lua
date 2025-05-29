local plug = require("util.plug")

return {
  "akinsho/toggleterm.nvim",
  opts = {
    open_mapping = { [[<C-\>]], [[<C-¥>]] },
  },
  keys = function()
    local lazy_ins
    local function lazygit()
      if lazy_ins == nil then
        lazy_ins = plug["toggleterm.terminal"].Terminal:new({
          cmd = "lazygit",
          direction = "float",
          hidden = true,
        })
      end
      return lazy_ins
    end
    return {
      [[<C-\>]],
      [[<C-¥>]],
      { "<leader>lg", function() lazygit():toggle() end },
      { "<S-esc>",    [[<C-\><C-n>]],                   mode = "t" },
      { "<C-w>",      [[<C-\><C-n><C-w>]],              mode = "t" },
    }
  end
}
