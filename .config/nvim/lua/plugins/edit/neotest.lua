local plug = require("util.plug")

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "sidlatau/neotest-dart",
  },
  keys = function()
    local t = plug.lazy.neotest
    return {
      { "<leader>Ta", function() t().run.run({ strategy = "dap" }) end },
      { "<leader>Tc", function() t().run.run({ vim.fn.expand("%"), strategy = "dap" }) end },
      { "<leader>To", function() t().output.toggle() end },
      { "<leader>TO", function() t().output_panel.toggle() end },
      { "<leader>Ts", function() t().summary.toggle() end },
      { "<leader>Td", function() t().diagnostic.toggle() end },
    }
  end,
  config = function()
    plug.neotest.setup {
      adapters = {
        plug["neotest-dart"] {
          use_lsp = true,
        },
      },
      summary = {
        mappings = {
          jumpto = "o",
          output = "O",
        },
      },
    }
  end,
}
