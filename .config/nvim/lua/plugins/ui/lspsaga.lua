local cmd = require("util.cmd")

return {
  "nvimdev/lspsaga.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    symbol_in_winbar = {
      enable = false,
    },
    lightbulb = {
      enable = false,
    },
    definition = {
      width = 0.8,
      height = 0.8,
      keys = {
        split = "<C-s>",
        vsplit = "<C-v>",
      },
    },
    callhierarchy = {
      keys = {
        edit = "o",
        split = "<C-s>",
        vsplit = "<C-v>",
      },
    },
    code_action = {
      extend_gitsigns = true,
    },
    finder = {
      max_height = 0.8,
      left_width = 0.3,
      right_width = 0.5,
      keys = {
        toggle_or_open = "o",
        shuttle = "<C-o>",
        split = "<C-s>",
        vsplit = "<C-v>",
      },
    },
    outline = {
      layout = "float",
      keys = {
        toggle_or_jump = "o",
      },
    }
  },
  keys = function()
    local goto_def_sp_top = function()
      vim.cmd "split"
      vim.cmd "Lspsaga goto_definition"
    end
    local goto_def_sp_bottom = function()
      vim.cmd "split"
      vim.cmd "wincmd j"
      vim.cmd "Lspsaga goto_definition"
    end
    local goto_def_sp_left = function()
      vim.cmd "vsplit"
      vim.cmd "Lspsaga goto_definition"
    end
    local goto_def_sp_right = function()
      vim.cmd "vsplit"
      vim.cmd "wincmd l"
      vim.cmd "Lspsaga goto_definition"
    end
    return {
      { "K",           cmd "Lspsaga hover_doc" },
      { "g[",          cmd "Lspsaga diagnostic_jump_prev" },
      { "g]",          cmd "Lspsaga diagnostic_jump_next" },
      { "gd",          cmd "Lspsaga goto_definition" },
      { "gD",          cmd "Lspsaga peek_definition" },
      { "go",          cmd "Lspsaga outline" },
      { "gr",          cmd "Lspsaga finder" },
      { "<leader>ac",  cmd "Lspsaga code_action" },
      { "<leader>ac",  cmd "Lspsaga code_action",         mode = "x" },
      { "<leader>rn",  cmd "Lspsaga rename" },
      { "<leader>gDh", goto_def_sp_left },
      { "<leader>gDj", goto_def_sp_bottom },
      { "<leader>gDk", goto_def_sp_top },
      { "<leader>gDl", goto_def_sp_right },
    }
  end,
}
