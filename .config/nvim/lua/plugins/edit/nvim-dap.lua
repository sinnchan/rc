local plug = require("util.plug")

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "folke/neodev.nvim",
    "nvim-neotest/nvim-nio",
  },
  keys = function()
    local dap = plug.lazy.dap
    return {
      { "<leader>dd", function() dap().toggle_breakpoint() end },
      { "<leader>dD", function() dap().clear_breakpoints() end },
      { "<leader>dl", function() dap().list_breakpoints() end },
      { "<leader>dn", function() dap().step_over() end },
      { "<leader>di", function() dap().step_into() end },
      { "<leader>do", function() dap().step_out() end },
      { "<leader>dc", function() dap().continue() end },
      { "<leader>dC", function() dap().disconnect() end },
      { "<leader>de", function() dap().set_exception_breakpoints() end },
      { "<leader>dE", function() dap().set_exception_breakpoints({}) end },
    }
  end,
}
