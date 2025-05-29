local plug = require("util.plug")
local icons = require("util.icons")

return {
  "b0o/incline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local devicons = plug["nvim-web-devicons"]
    plug.incline.setup {
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then filename = "[No Name]" end
        local ft_icon, ft_color = devicons.get_icon_color(filename)

        local function get_git_diff()
          local ic = { "added", "changed", "removed", }
          local signs = vim.b[props.buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then return labels end
          for _, name in ipairs(ic) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icons[name] .. signs[name] .. " ", group = "Diff" .. name })
            end
          end
          if #labels > 0 then table.insert(labels, { "┊ " }) end
          return labels
        end

        local function get_diagnostic_label()
          local ic = { "error", "warn", "info", "hint" }
          local label = {}

          for _, severity in ipairs(ic) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icons[severity] .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then table.insert(label, { "┊ " }) end
          return label
        end

        return {
          { get_git_diff() },
          { get_diagnostic_label() },
          { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
          { filename .. " ",        gui = "bold" },
        }
      end,
    }
  end,
}
