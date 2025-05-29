local plug = require("util.plug")

return {
  "akinsho/flutter-tools.nvim",
  ft = { "dart" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    fvm = false,
    widget_guides = {
      enabled = true,
    },
    debugger = {
      enabled = true,
      run_via_dap = true,
    },
    decorations = {
      project_config = true,
    },
    lsp = {
      color = {
        enabled = true,
        background = true,
        background_color = { r = 40, g = 44, b = 52 },
      },
      settings = {
        renameFilesWithClasses = "always",
        updateImportsOnRename = true,
        analysisExcludedFolders = {
          ".dart_tool/",
          vim.fn.expand("~") .. "/.pub-cache/",
          vim.fn.expand("~") .. "/fvm/",
          vim.fn.expand("~") .. "/.local/share/mise",
        },
      },
    },
  },
  config = function(_, opts)
    local tools = plug["flutter-tools"]
    tools.setup(opts)

    local is_loaded, mod = pcall(require, "local_flutter_proj")
    if is_loaded then
      tools.setup_project(mod.projects)
    end

    local lsp = plug.lazy["flutter-tools.lsp"]
    vim.api.nvim_create_user_command(
      "FlutterLspAttach",
      function() lsp().attach() end,
      {}
    )
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.dart",
      callback = function() lsp().attach() end,
    })
  end
}
