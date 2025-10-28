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
      {
        "<leader>dd",
        function() dap().toggle_breakpoint() end,
        desc = "Toggle breakpoint"
      },
      {
        "<leader>dD",
        function() dap().clear_breakpoints() end,
        desc = "Clear all breakpoints"
      },
      {
        "<leader>dl",
        function() dap().list_breakpoints() end,
        desc = "List breakpoints"
      },
      {
        "<leader>dn",
        function() dap().step_over() end,
        desc = "Step over"
      },
      {
        "<leader>di",
        function() dap().step_into() end,
        desc = "Step into"
      },
      {
        "<leader>do",
        function() dap().step_out() end,
        desc = "Step out"
      },
      {
        "<leader>dc",
        function() dap().continue() end,
        desc = "Continue execution"
      },
      {
        "<leader>dC",
        function() dap().disconnect() end,
        desc = "Disconnect debugger"
      },
      {
        "<leader>de",
        function() dap().set_exception_breakpoints() end,
        desc = "Set exception breakpoints"
      },
      {
        "<leader>dE",
        function() dap().set_exception_breakpoints({}) end,
        desc = "Clear exception breakpoints"
      },
    }
  end,
}
