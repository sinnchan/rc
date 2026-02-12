local plug = require("util.plug")

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function(_, _)
    local ts_fts = {
      "lua",
      "bash",
      "zsh",
      "c",
      "cpp",
      "vim",
      "rust",
      "dart",
      "javascript",
      "typescript",
    }
    plug["nvim-treesitter"].install(ts_fts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ts_fts,
      callback = function(args)
        vim.treesitter.start(args.buf)
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
      end,
    })
  end
}
