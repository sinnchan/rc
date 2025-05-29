return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(buf)
      local gs = package.loaded.gitsigns
      local function _map(mode, l, r, o)
        o = o or {}
        o.buffer = buf
        vim.keymap.set(mode, l, r, o)
      end

      _map("n", "<leader>h]", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true })

      _map("n", "<leader>h[", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true })

      _map("n", "<leader>hs", gs.stage_hunk)
      _map("n", "<leader>hr", gs.reset_hunk)
      _map("n", "<leader>hS", gs.stage_buffer)
      _map("n", "<leader>hu", gs.undo_stage_hunk)
      _map("n", "<leader>hR", gs.reset_buffer)
      _map("n", "<leader>hp", gs.preview_hunk)
      _map("n", "<leader>hd", gs.diffthis)
      _map("n", "<leader>ht", gs.toggle_deleted)
      _map("n", "<leader>hT", gs.toggle_current_line_blame)
      _map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
      _map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
      _map("n", "<leader>hb", function() gs.blame_line { full = true } end)
      _map("n", "<leader>hD", function() gs.diffthis("~") end)
      _map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
  },
}
