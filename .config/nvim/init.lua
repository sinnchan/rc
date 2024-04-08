-- path
package.path = package.path .. ";" .. os.getenv("HOME") .. "/?.lua"

-- init
vim.g.NERDCreateDefaultMappings = 0
vim.g.mapleader = " "
vim.o.showtabline = 2
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.colorcolumn = "80"
vim.opt.confirm = true
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.imdisable = true
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true;
vim.opt.title = true
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.wrapscan = false
vim.opt.writebackup = false

-- color
local custom_colors = function()
  vim.api.nvim_set_hl(0, "Search", { fg = "#19ffb2", underline = true })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = "#19ffb2", underline = true })
  vim.api.nvim_set_hl(0, "CurSearch", { fg = "black", bg = "#19ffb2" })
end

-- func
local cmd = function(command)
  return table.concat({ "<CMD>", command, "<CR>" })
end

local onLspAttach = function(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = callback,
  })
end

-- default vim keymap
Map = vim.keymap.set
Map("n", "<C-l>", "10zl")
Map("n", "<C-h>", "10zh")
Map("n", "<leader>rr", cmd "source ~/.config/nvim/init.lua", { silent = true })
Map("n", "<leader>ro", cmd "e ~/.config/nvim/init.lua", { silent = true })

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- setup
local lazy_opts = {
  defaults = { lazy = true },
}

local plugins = {
  { "folke/lazy.nvim" },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    opts = { transparent = true },
    config = function(_, opts)
      local onedark = require("onedark")
      onedark.setup(opts)
      onedark.load()
      custom_colors();
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "onedark" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/playground",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = { "c", "lua", "vim", "dart" },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "fannheyward/telescope-coc.nvim",
    },
    config = function()
      local ts = require("telescope")
      ts.load_extension("textcase")
      ts.load_extension("emoji")
      ts.load_extension("noice")
    end,
    keys = function()
      local ts = require("telescope")
      local builtin = require("telescope.builtin")
      return {
        { "<leader>ff", builtin.find_files },
        { "<leader>fl", builtin.live_grep },
        { "<leader>fb", builtin.buffers },
        { "<leader>fm", builtin.marks },
        { "<leader>fc", builtin.commands },
        { "<leader>fg", builtin.git_status },
        { "<leader>fd", builtin.diagnostics },
        { "<leader>fe", ts.extensions.emoji.emoji },
        { "<leader>fn", ts.extensions.noice.noice },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    priority = 502,
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    priority = 501,
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "b0o/schemastore.nvim",
    },
    opts = {
      automatic_installation = true,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          }
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup {
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          }
        end,
        ["jsonls"] = function()
          require("lspconfig").jsonls.setup {
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          }
        end,
        ["yamlls"] = function()
          require("lspconfig").yamlls.setup {
            settings = {
              yaml = {
                schemaStore = {
                  enable = false,
                  url = "",
                },
                schemas = require("schemastore").yaml.schemas(),
              },
            },
          }
        end
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    priority = 500,
    event = "VeryLazy",
    keys = {
      { "<leader>e", vim.diagnostic.open_float },
      { "<leader>q", vim.diagnostic.setloclist },
    },
    config = function()
      onLspAttach(function(ev)
        local lsp_b = vim.lsp.buf
        local opts = { buffer = ev.buf }
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        Map("n", "gc", lsp_b.declaration, opts)
        Map("n", "gi", lsp_b.implementation, opts)
        Map("n", "<C-k>", lsp_b.signature_help, opts)
        Map("n", "<leader>wa", lsp_b.add_workspace_folder, opts)
        Map("n", "<leader>wr", lsp_b.remove_workspace_folder, opts)
        Map("n", "<leader>fa", function() lsp_b.format { async = true } end, opts)
      end)
    end,
  },
  {
    "folke/neodev.nvim",
    priority = 525,
    event = "VeryLazy",
    opts = {
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      lightbulb = {
        enable = false,
      },
      definition = {
        width = 0.8,
        height = 0.8,
        keys = {
          split = "<C-c>s",
          vsplit = "<C-c>x",
        },
      },
      callhierarchy = {
        keys = {
          split = "<C-s>",
          vsplit = "<C-x>",
        },
      },
      code_action = {
        extend_gitsigns = true,
      },
      finder = {
        max_height = 0.8,
        left_width = 0.3,
        right_width = 0.5,
        keys = {
          shuttle = "<C-o>",
          split = "<C-s>",
          vsplit = "<C-x>",
        },
      },
      outline = {
        layout = "float",
      }
    },
    keys = function()
      local goto_def_sp_top = function()
        vim.cmd "split"
        vim.cmd "Lspsaga goto_definition"
      end
      local goto_def_sp_bottom = function()
        vim.cmd "split"
        vim.cmd "wincmd j"
        vim.cmd "Lspsaga goto_definition"
      end
      local goto_def_sp_left = function()
        vim.cmd "vsplit"
        vim.cmd "Lspsaga goto_definition"
      end
      local goto_def_sp_right = function()
        vim.cmd "vsplit"
        vim.cmd "wincmd l"
        vim.cmd "Lspsaga goto_definition"
      end
      return {
        { "K",           cmd "Lspsaga hover_doc" },
        { "g[",          cmd "Lspsaga diagnostic_jump_prev" },
        { "g]",          cmd "Lspsaga diagnostic_jump_next" },
        { "gd",          cmd "Lspsaga goto_definition" },
        { "gD",          cmd "Lspsaga peek_definition" },
        { "go",          cmd "Lspsaga outline" },
        { "gr",          cmd "Lspsaga finder" },
        { "<leader>ci",  cmd "Lspsaga incoming_calls" },
        { "<leader>co",  cmd "Lspsaga outgoing_calls" },
        { "<leader>ac",  cmd "Lspsaga code_action" },
        { "<leader>ac",  cmd "Lspsaga code_action",         mode = "x" },
        { "<leader>rn",  cmd "Lspsaga rename" },
        { "<leader>gDh", goto_def_sp_left },
        { "<leader>gDj", goto_def_sp_bottom },
        { "<leader>gDk", goto_def_sp_top },
        { "<leader>gDl", goto_def_sp_right },
      }
    end,
  },

  -- languages

  { "udalov/kotlin-vim" },
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      fvm = true,
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
          },
        },
      },
    },
    config = function(_, opts)
      local tools = require("flutter-tools")
      tools.setup(opts)

      local is_loaded, mod = pcall(require, "local_flutter_proj")
      if is_loaded then
        tools.setup_project(mod.projects)
      end
    end
  },
  {
    "hrsh7th/nvim-cmp",
    priority = 200,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "onsails/lspkind.nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
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
          { { name = "nvim_lsp" }, { name = "vsnip" } },
          { { name = "buffer" } }
        ),
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
          },
        },
      }
    end,
    config = function(_, opts)
      local pairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", pairs.on_confirm_done())
      cmp.setup(opts)
    end,
  },
  {
    "hrsh7th/vim-vsnip",
    config = function()
      local opts = { expr = true, noremap = false }
      Map({ "n", "s" }, "<s>", [[<Plug>(vsnip-select-text)]], opts)
      Map({ "n", "s" }, "<S>", [[<Plug>(vsnip-cut-text)]], opts)
      Map({ "i", "s" }, "<Tab>",
        function() return vim.fn["vsnip#jumpable"](1) == 1 and "<Plug>(vsnip-jump-next)" or "<Tab>" end, opts)
      Map({ "i", "s" }, "<S-Tab>",
        function() return vim.fn["vsnip#jumpable"](-1) == 1 and "<Plug>(vsnip-jump-prev)" or "<S-Tab>" end, opts)
    end
  },
  {
    "mfussenegger/nvim-dap",
    priority = 550,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "folke/neodev.nvim",
      "nvim-neotest/nvim-nio",
    },
    keys = function()
      local dap = require("dap")
      return {
        { "<leader>dd", dap.toggle_breakpoint },
        { "<leader>dD", dap.clear_breakpoints },
        { "<leader>dl", dap.list_breakpoints },
        { "<leader>dn", dap.step_over },
        { "<leader>di", dap.step_into },
        { "<leader>do", dap.step_out },
        { "<leader>dc", dap.continue },
        { "<leader>dC", dap.disconnect },
        { "<leader>de", function() dap.set_exception_breakpoints() end },
        { "<leader>dE", function() dap.set_exception_breakpoints({}) end },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    main = "dapui",
    config = true,
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = function()
      local ui = require("dapui")
      return {
        { "<leader>du", function() ui.toggle() end }
      }
    end,
  },
  {
    "windwp/nvim-autopairs",
    priority = 300,
    event = "InsertEnter",
    opts = {
      enable_check_bracket_line = false,
      map_cr = true,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "InsertEnter",
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { sort_by = "case_sensitive" },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true
    end,
    keys = function()
      local tree = require("nvim-tree.api")
      return {
        { "<leader>to", tree.tree.open },
        { "<leader>tc", tree.tree.close },
        { "<leader>tt", tree.tree.toggle },
        { "<leader>tg", tree.tree.focus },
        { "<leader>tf", tree.tree.find_file },
        { "<leader>tr", tree.tree.reload },
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = {
        highlight = { "IndentLineColor" },
        char = "▏",
      },
      scope = {
        enabled = false,
      },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IndentLineColor", { fg = "#303336" })
      end)
      require("ibl").setup(opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      on_attach = function(buf)
        local gs = package.loaded.gitsigns
        local function _map(mode, l, r, o)
          o = o or {}
          o.buffer = buf
          Map(mode, l, r, o)
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
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = { easing_function = "quintic" },
    config = function(_, opts)
      require("neoscroll").setup(opts)
      require("neoscroll.config").set_mappings({
        ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } },
        ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } },
        ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "160" } },
        ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "160" } },
        ["<C-y>"] = { "scroll", { "-0.10", "false", "40" } },
        ["<C-e>"] = { "scroll", { "0.10", "false", "40" } },
        ["zt"] = { "zt", { "80" } },
        ["zz"] = { "zz", { "80" } },
        ["zb"] = { "zb", { "80" } },
      })
    end,
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)" },
      { "ga", "<Plug>(EasyAlign)", mode = "x" },
    },
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = "CccPick",
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
  },
  {
    "sindrets/winshift.nvim",
    keys = {
      { "<C-W>m", cmd "WinShift swap" },
      { "<C-W>M", cmd "WinShift" },
    },
  },
  {
    "johmsalas/text-case.nvim",
    opts = {
      pickers = {
        find_files = { follow = true }
      }
    },
    keys = { { "<leader>fC", cmd "TextCaseOpenTelescope" } },
  },
  {
    "yorickpeterse/nvim-window",
    keys = function()
      return { { "<C-w>f", require("nvim-window").pick, noremap = false } }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
    keys = {
      { "<C-w>z", cmd "WindowsMaximize" },
      { "<C-w>_", cmd "WindowsMaximizeVertically" },
      { "<C-w>|", cmd "WindowsMaximizeHorizontally" },
      { "<C-w>=", cmd "WindowsEqualize" },
    },
  },
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    opts = {
      theme = {
        fill = "TabLineFill",
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      },
      nerdfont = true,
      lualine_theme = "onedark",
      buf_name = { mode = "unique" },
    },
    config = function(_, opts)
      require("tabby.tabline").use_preset("tab_only", opts)
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = function()
      local spectre = require("spectre")
      return {
        { "<leader>S",  spectre.toggle },
        { "<leader>sw", spectre.open_visual },
        { "<leader>sp", spectre.open_file_search },
      }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {},
    keys = function()
      local lazygit = require("toggleterm.terminal").Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true,
      })
      return {
        { "<leader>lg", function() lazygit:toggle() end },
      }
    end
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {},
  },
  {
    "smoka7/hop.nvim",
    enabled = false,
    version = "*",
    opts = {
      keys = "abcefhjkmnprstuvwxyz.2345678",
      uppercase_labels = true,
      multi_windows = true,
    },
    keys = function()
      return { { "f", function() require("hop").hint_char1({}) end } }
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    main = "notify",
    opts = { background_colour = "#000000" },
  },
  {
    -- lsp ui
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "dinhhuy258/git.nvim",
    cmd = { "GitBlame" },
    config = true,
  },
}

require("lazy").setup(plugins, lazy_opts)
