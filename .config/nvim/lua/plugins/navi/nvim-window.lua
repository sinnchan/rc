local plug = require("util.plug")
return {
  "yorickpeterse/nvim-window",
  keys = function()
    local pick = function() plug["nvim-window"].pick() end
    return { { "<C-w>f", pick, noremap = false } }
  end,
}
