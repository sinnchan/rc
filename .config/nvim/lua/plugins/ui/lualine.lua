local plug = require("util.plug")
local icons = require("util.icons")
local function selectionCount()
  local mode = vim.fn.mode()
  local start_line, end_line, start_pos, end_pos

  if not (mode:find("[vV\22]") ~= nil) then return "" end
  start_line = vim.fn.line("v")
  end_line = vim.fn.line(".")

  if mode == 'V' then
    start_pos = 1
    end_pos = vim.fn.strlen(vim.fn.getline(end_line)) + 1
  else
    start_pos = vim.fn.col("v")
    end_pos = vim.fn.col(".")
  end

  local chars = 0
  for i = start_line, end_line do
    local line = vim.fn.getline(i)
    local line_len = vim.fn.strlen(line)
    local s_pos = (i == start_line) and start_pos or 1
    local e_pos = (i == end_line) and end_pos or line_len + 1
    chars = chars + vim.fn.strchars(line:sub(s_pos, e_pos - 1))
  end

  local lines = math.abs(end_line - start_line) + 1
  return tostring(lines) .. " lines, " .. tostring(chars) .. " characters"
end

return {
  "nvim-lualine/lualine.nvim",
  priority = 1000,
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local recording = function()
      local reg = vim.fn.reg_recording()
      if reg == "" then return "" else return "Recording @" .. reg end
    end
    local diff = {
      "diff",
      symbols = {
        added = icons.added,
        removed = icons.removed,
        modified = icons.changed,
      },
    }
    local diag = { "diagnostics", symbols = icons }

    plug.lualine.setup({
      options = { theme = "onedark" },
      sections = {
        lualine_a = { "mode", { "macro-recording", fmt = recording } },
        lualine_b = { diff, diag },
        lualine_c = { "filename" },
        lualine_x = { { selectionCount }, "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
