local plug = require("util.plug")

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = (function()
    local args = vim.fn.argv()
    if #args == 0 then return true end
    local attr = vim.loop.fs_stat(args[1])
    if attr and attr.type == "directory" then
      return false
    end
    return true
  end)(),
  opts = {
    sort_by = "case_sensitive",
    filters = {
      custom = {
        ".g.dart$",
        ".freezed.dart$",
      },
    },
  },
  config = function(_, opts)
    plug["nvim-tree"].setup(opts)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true
  end,
  keys = function()
    local tree = plug.lazy["nvim-tree.api"]
    return {
      { "<leader>to", function() tree().tree.open() end },
      { "<leader>tc", function() tree().tree.close() end },
      { "<leader>tt", function() tree().tree.toggle() end },
      { "<leader>tg", function() tree().tree.focus() end },
      { "<leader>tf", function() tree().tree.find_file() end },
      { "<leader>tr", function() tree().tree.reload() end },
    }
  end,
}
