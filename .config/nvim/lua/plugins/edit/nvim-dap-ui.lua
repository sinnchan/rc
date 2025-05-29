local plug = require("util.plug")

return {
  "rcarriga/nvim-dap-ui",
  main = "dapui",
  dependencies = { "nvim-neotest/nvim-nio" },
  keys = function()
    return {
      { "<leader>du", function() plug.lazy.dapui().toggle() end },
    }
  end,
  config = function()
    plug.dapui.setup()
    plug["nvim-dap-virtual-text"].setup()
  end,
}
