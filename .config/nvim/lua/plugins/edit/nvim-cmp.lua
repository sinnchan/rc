local plug = require("util.plug")

return {
  "hrsh7th/nvim-cmp",
  priority = 200,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-emoji",
    "hrsh7th/vim-vsnip",
    "onsails/lspkind.nvim",
  },
  opts = function()
    local cmp = plug.cmp
    return {
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = function(fallback)
          if cmp.visible() then cmp.select_next_item() else fallback() end
        end,
        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then cmp.select_prev_item() else fallback() end
        end,
      },
      sources = cmp.config.sources(
        {
          { name = "nvim_lsp" },
          { name = "vsnip" },
        },
        { { name = "buffer" } }
      ),
      formatting = {
        format = plug.lspkind.cmp_format {
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
          preset = "codicons",
        },
      },
    }
  end,
  config = function(_, opts)
    local pairs = plug["nvim-autopairs.completion.cmp"]
    plug.cmp.event:on("confirm_done", pairs.on_confirm_done())
    plug.cmp.setup(opts)
  end,
}
