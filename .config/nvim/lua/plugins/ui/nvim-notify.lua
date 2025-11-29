return {
  "rcarriga/nvim-notify",
  opts = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    local bg = normal and normal.bg or nil

    return {
      background_colour = bg and string.format("#%06x", bg) or "#000000",
    }
  end,
}
