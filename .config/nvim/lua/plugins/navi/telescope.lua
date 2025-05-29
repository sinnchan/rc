local plug = require("util.plug")
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "xiyaowong/telescope-emoji.nvim",
    "fannheyward/telescope-coc.nvim",
  },
  config = function()
    plug.telescope.load_extension("textcase")
    plug.telescope.load_extension("emoji")
    plug.telescope.load_extension("noice")
  end,
  keys = function()
    local ts = plug.lazy.telescope
    local bl = plug.lazy["telescope.builtin"]
    return {
      { "<leader>ff", function() bl().find_files() end },
      { "<leader>fl", function() bl().live_grep() end },
      { "<leader>fb", function() bl().buffers() end },
      { "<leader>fm", function() bl().marks() end },
      { "<leader>fc", function() bl().commands() end },
      { "<leader>fg", function() bl().git_status() end },
      { "<leader>fd", function() bl().diagnostics() end },
      { "<leader>fe", function() ts().extensions.emoji.emoji() end },
      { "<leader>fn", function() ts().extensions.noice.noice() end },
    }
  end,
}
