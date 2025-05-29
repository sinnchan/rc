local icons = require("util.icons")
local home = os.getenv("HOME")
if home then
  package.path = package.path .. ";" .. home .. "/?.lua"
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.INFO] = icons.info,
      [vim.diagnostic.severity.HINT] = icons.hint,
    },
  },
})

require("config")
