local plug = require("util.plug")
local typo_file = '~/.config/nvim/spell/.typos.toml'
local lsps = {
  "bashls",
  "html",
  "jsonls",
  "kotlin_language_server",
  "lua_ls",
  "pylsp",
  "rust_analyzer",
  "ts_ls",
  "typos_lsp",
  "yamlls",
}

return {
  "mason-org/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "b0o/schemastore.nvim",
    "zapling/mason-lock.nvim",
  },
  opts = {
    automatic_installation = true,
    ensure_installed = lsps,
  },
  config = function(_, opts)
    plug["mason-lspconfig"].setup(opts)
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            globals = { "vim", "require" },
          },
        },
      },
    })
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = plug.schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    })
    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = plug.schemastore.yaml.schemas(),
        },
      },
    })
    vim.lsp.config("typos_lsp", {
      init_options = {
        config = typo_file,
        diagnosticSeverity = "Hint",
      },
    })
    vim.lsp.enable(lsps)
  end,
}
