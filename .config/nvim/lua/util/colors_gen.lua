local M = {}

local function hex_to_rgb(hex)
  local _hex = hex:gsub("#", "")
  return tonumber(_hex:sub(1, 2), 16),
         tonumber(_hex:sub(3, 4), 16),
         tonumber(_hex:sub(5, 6), 16)
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function leap(rgb1, rgb2, blend)
  local r1, g1, b1 = hex_to_rgb(rgb1)
  local r2, g2, b2 = hex_to_rgb(rgb2)

  local r = math.floor(r1 + (r2 - r1) * blend)
  local g = math.floor(g1 + (g2 - g1) * blend)
  local b = math.floor(b1 + (b2 - b1) * blend)

  return rgb_to_hex(r, g, b)
end

local function gen_gradient(color_list, count)
  local output = {}
  local num_intervals = count - 1
  local num_colors = #color_list - 1

  for i = 0, num_intervals do
    local position = i / num_intervals
    local index = math.floor(position * num_colors)
    local blend = (position * num_colors) % 1

    table.insert(
      output,
      leap(
        color_list[index + 1],
        color_list[math.min(index + 2, #color_list)],
        blend
      )
    )
  end

  return output
end

local default_config = {
  gradient_level = 12,
  background = "#323844",
  base_colors = {
    "#34A853",
    "#4285F4",
    "#EA4335",
    "#FBBC05",
  },
}

M.indent_colors = {}
M.delimiter_colors = {}
M.scope_color_keys = {}
M.indent_color_keys = {}

function M.setup(config)
  config = config or {}

  -- Normal の背景色からデフォルト背景を拾う
  local ok, normal_hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
  if ok and normal_hl and normal_hl.bg ~= nil then
    default_config.background = string.format("#%06x", normal_hl.bg)
  end

  setmetatable(config, { __index = default_config })

  -- 再セットアップ時に前回の状態をクリア
  M.indent_colors = {}
  M.delimiter_colors = {}
  M.scope_color_keys = {}
  M.indent_color_keys = {}

  local colors = gen_gradient(config.base_colors, config.gradient_level)

  for i, _color in ipairs(colors) do
    -- delimiter colors
    local delimiter_color_key = "DelimiterColor" .. i
    table.insert(M.delimiter_colors, { key = delimiter_color_key, color = _color })
    table.insert(M.scope_color_keys, delimiter_color_key)

    -- indent colors（背景とブレンド）
    local indent_color_key = "IndentColor" .. i
    local background = config.background
    local indent_color = background and leap(_color, background, 0.8) or _color
    table.insert(M.indent_colors, { key = indent_color_key, color = indent_color })
    table.insert(M.indent_color_keys, indent_color_key)
  end
end

function M.apply()
  for _, pair in ipairs(M.indent_colors) do
    vim.api.nvim_set_hl(0, pair.key, { fg = pair.color })
  end
  for _, pair in ipairs(M.delimiter_colors) do
    vim.api.nvim_set_hl(0, pair.key, { fg = pair.color })
  end
end

return M

