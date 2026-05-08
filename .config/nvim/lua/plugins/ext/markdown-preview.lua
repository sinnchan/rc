return {
  "sinnchan/markdown-preview.nvim",
  branch = "update-mermaid",
  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewStop",
  },
  ft = { "markdown" },
  build = function()
    vim.cmd [[Lazy load markdown-preview.nvim]]
    vim.fn['mkdp#util#install']()
  end,
  init = function ()
    vim.g.mkdp_auto_close = 0
  end,
}
