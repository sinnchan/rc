return {
  "hrsh7th/vim-vsnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local opts = { expr = true, noremap = false }
    vim.keymap.set({ "n", "s" }, "<s>", [[<Plug>(vsnip-select-text)]], opts)
    vim.keymap.set({ "n", "s" }, "<S>", [[<Plug>(vsnip-cut-text)]], opts)
    vim.keymap.set({ "i", "s" }, "<Tab>",
      function() return vim.fn["vsnip#jumpable"](1) == 1 and "<Plug>(vsnip-jump-next)" or "<Tab>" end, opts)
    vim.keymap.set({ "i", "s" }, "<S-Tab>",
      function() return vim.fn["vsnip#jumpable"](-1) == 1 and "<Plug>(vsnip-jump-prev)" or "<S-Tab>" end, opts)
  end
}
