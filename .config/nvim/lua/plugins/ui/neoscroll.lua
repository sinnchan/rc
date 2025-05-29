local plug = require("util.plug")

return {
  "karb94/neoscroll.nvim",
  cond = not vim.g.neovide,
  event = "VeryLazy",
  opts = {
    easing = "quadratic",
    performance_mode = true,
  },
  config = function(_, opts)
    local s = plug.neoscroll
    local d = 200
    s.setup(opts)

    local m = { 'n', 'v', 'x' }
    vim.keymap.set(m, "<C-u>", function() s.ctrl_u({ duration = d }) end)
    vim.keymap.set(m, "<C-d>", function() s.ctrl_d({ duration = d }) end)
    vim.keymap.set(m, "<C-b>", function() s.ctrl_b({ duration = d * 1.5 }) end)
    vim.keymap.set(m, "<C-f>", function() s.ctrl_f({ duration = d * 1.5 }) end)
    vim.keymap.set(m, "<C-y>", function() s.scroll(-0.1, { move_cursor = false, duration = d / 2 }) end)
    vim.keymap.set(m, "<C-e>", function() s.scroll(0.1, { move_cursor = false, duration = d / 2 }) end)
    vim.keymap.set(m, "zt", function() s.zt({ half_win_duration = d }) end)
    vim.keymap.set(m, "zz", function() s.zz({ half_win_duration = d }) end)
    vim.keymap.set(m, "zb", function() s.zb({ half_win_duration = d }) end)
  end,
}
