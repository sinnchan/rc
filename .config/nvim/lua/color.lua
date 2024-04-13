local color = {}

function color.hex_to_rgb(hex)
  local _hex = hex:gsub("#", "")
  return tonumber(_hex:sub(1, 2), 16), tonumber(_hex:sub(3, 4), 16), tonumber(_hex:sub(5, 6), 16)
end

function color.rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

function color.gen_gradient(color_list, count)
  local output = {}
  local num_intervals = count - 1
  local num_colors = #color_list - 1

  for i = 0, num_intervals do
    local position = i / num_intervals
    local index = math.floor(position * num_colors)
    local blend = (position * num_colors) % 1

    table.insert(
      output,
      color.leap(
        color_list[index + 1],
        color_list[math.min(index + 2, #color_list)],
        blend
      )
    )
  end

  return output
end

function color.leap(rgb1, rgb2, blend)
  local r1, g1, b1 = color.hex_to_rgb(rgb1)
  local r2, g2, b2 = color.hex_to_rgb(rgb2)

  local r = math.floor(r1 + (r2 - r1) * blend)
  local g = math.floor(g1 + (g2 - g1) * blend)
  local b = math.floor(b1 + (b2 - b1) * blend)

  return color.rgb_to_hex(r, g, b)
end

return color
