local plug = require("util.plug")

return {
  "nvim-pack/nvim-spectre",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "noib3/nvim-oxi",
  },
  build = "./build.sh",
  opts = {
    default = {
      replace = {
        cmd = "oxi",
      },
    },
  },
  keys = function()
    local sp = plug.lazy.spectre
    return {
      { "<leader>S",  function() sp().toggle() end },
      { "<leader>sw", function() sp().open_visual() end },
      { "<leader>sp", function() sp().open_file_search() end },
    }
  end,
}
