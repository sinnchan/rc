local plug = require("util.plug")

return {
  "cleong14/mason-lock.nvim",
  branch = "main",
  config = function()
    plug["mason-lock"].setup({
      lockfile_path = vim.fn.stdpath("config") .. "/mason/mason-lock.json",
    })
  end
}
