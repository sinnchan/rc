local plug = require("util.plug")
return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  keys = {
    { "<leader>e", vim.diagnostic.open_float },
    { "<leader>q", vim.diagnostic.setloclist },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local lsp_b = vim.lsp.buf
        local opts = { buffer = ev.buf }
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        vim.keymap.set("n", "gi", lsp_b.implementation, opts)
        vim.keymap.set("n", "<leader>wa", lsp_b.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", lsp_b.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>fa", function() plug.lazy.conform().format { async = true, bufnr = ev.buf } end, opts)
      end,
    })
  end,
}
