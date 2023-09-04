local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local actions = require'telescope.actions'

local M = {}

M.analyze_flutter = function()
  local handle = io.popen("flutter analyze")

  if handle == nil then
    return
  end

  local result = handle:read("*a")
  handle:close()

  local results = {}
  for line in result:gmatch("[^\r\n]+") do
    for severity, file, _line, col, msg in line:gmatch("(%w+) • (.+)%:(%d+)%:(%d+) • (.+)") do
      table.insert(results, {
        file = file,
        line = tonumber(_line),
        col = tonumber(col),
        text = severity .. ": " .. msg
      })
    end
  end

  pickers.new({}, {
    prompt_title = 'Flutter hoge',
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          display = entry.text,
          ordinal = entry.text,
          value = entry,
        }
      end,
    },
    sorter = require'telescope.sorters'.get_fuzzy_file(),
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = actions.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.cmd(string.format('e %s', selection.value.file))
        vim.cmd(string.format('call cursor(%d, %d)', selection.value.line, selection.value.col))
      end)
      return true
    end
  }):find()
end

return M

