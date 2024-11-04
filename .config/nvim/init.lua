local home = os.getenv("HOME")
if home then
  package.path = package.path .. ";" .. home .. "/?.lua"
end

-- init
vim.g.NERDCreateDefaultMappings = 0
vim.g.mapleader = " "
vim.o.guifont = "ProFont IIx Nerd Font:h12"
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
vim.opt.incsearch = true
vim.opt.laststatus = 3
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

Map = vim.keymap.set

-- neovide
local enableScrollAnimation = true
if vim.g.neovide then
  enableScrollAnimation = false

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_text_gamma = 1.0
  vim.g.neovide_text_contrast = 3.0

  Map('v', '<D-c>', '"+y')         -- Copy
  Map('n', '<D-v>', '"+P')         -- Paste normal mode
  Map('v', '<D-v>', '"+P')         -- Paste visual mode
  Map('c', '<D-v>', '<C-R>+')      -- Paste command mode
  Map('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

local gpt_key =
"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"

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
local _opts = { noremap = true, silent = true }
Map("n", "<C-l>", "10zl")
Map("n", "<C-h>", "10zh")
Map("n", "<C-j>", "10gj")
Map("n", "<C-k>", "10gk")
Map("n", "<C-y>", "10<C-y>")
Map("n", "<C-e>", "10<C-e>")
Map("n", "n", "nzz", { remap = true })
Map("n", "N", "Nzz", { remap = true })
Map("n", "<leader>+", cmd "resize +10")
Map("n", "<leader>-", cmd "resize -10")
Map("n", "<leader>rr", cmd "source ~/.config/nvim/init.lua", _opts)
Map("n", "<leader>ro", cmd "e ~/.config/nvim/init.lua", _opts)
Map('', '<D-v>', '+p<CR>', _opts)
Map('!', '<D-v>', '<C-R>+', _opts)
Map('t', '<D-v>', '<C-R>+', _opts)
Map('v', '<D-v>', '<C-R>+', _opts)

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
    opts = {
      transparent = false,
      style = "dark",
      colors = {
        search = "#FFFF00",
      },
      highlights = {
        ["Search"] = { fg = "$search", bg = "NONE", underline = true },
        ["IncSearch"] = { fg = "$search", bg = "NONE", underline = true },
        ["CurSearch"] = { fg = "black", bg = "$search" },
      }
    },
    config = function(_, opts)
      local onedark = require("onedark")
      onedark.setup(opts)
      onedark.load()
      require("gradient_gen").apply()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    priority = 1000,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function recording()
        local reg = vim.fn.reg_recording()
        if reg == "" then return "" else return "Recording @" .. reg end
      end
      require("lualine").setup({
        options = { theme = "onedark" },
        sections = {
          lualine_a = { "mode", { "macro-recording", fmt = recording } },
          lualine_b = { "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "b0o/incline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup {
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then filename = "[No Name]" end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_git_diff()
            local icons = { removed = "-", changed = "~", added = "+" }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then return labels end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
              end
            end
            if #labels > 0 then table.insert(labels, { "┊ " }) end
            return labels
          end

          local function get_diagnostic_label()
            local icons = { error = " ", warn = " ", info = " ", hint = " " }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then table.insert(label, { "┊ " }) end
            return label
          end

          return {
            { get_diagnostic_label() },
            { get_git_diff() },
            { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
            { filename .. " ",        gui = "bold" },
          }
        end,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
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
      local ts = function() return require("telescope") end
      local builtin = function() return require("telescope.builtin") end
      return {
        { "<leader>ff", function() builtin().find_files() end },
        { "<leader>fl", function() builtin().live_grep() end },
        { "<leader>fb", function() builtin().buffers() end },
        { "<leader>fm", function() builtin().marks() end },
        { "<leader>fc", function() builtin().commands() end },
        { "<leader>fg", function() builtin().git_status() end },
        { "<leader>fd", function() builtin().diagnostics() end },
        { "<leader>fe", function() ts().extensions.emoji.emoji() end },
        { "<leader>fn", function() ts().extensions.noice.noice() end },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
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
                diagnostics = {
                  globals = {
                    "vim",
                    "require",
                  },
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
        end,
        ["ts_ls"] = function()
          require("lspconfig").ts_ls.setup {}
        end
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    keys = {
      { "<leader>e", vim.diagnostic.open_float },
      { "<leader>q", vim.diagnostic.setloclist },
    },
    config = function()
      onLspAttach(function(ev)
        local lsp_b = vim.lsp.buf
        local opts = { buffer = ev.buf }
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        Map("n", "gi", lsp_b.implementation, opts)
        Map("n", "<leader>wa", lsp_b.add_workspace_folder, opts)
        Map("n", "<leader>wr", lsp_b.remove_workspace_folder, opts)
        Map("n", "<leader>fa", function() lsp_b.format { async = true } end, opts)
      end)
    end,
  },
  {
    "folke/neodev.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
      definition = {
        width = 0.8,
        height = 0.8,
        keys = {
          split = "<C-s>",
          vsplit = "<C-v>",
        },
      },
      callhierarchy = {
        keys = {
          edit = "o",
          split = "<C-s>",
          vsplit = "<C-v>",
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
          toggle_or_open = "o",
          shuttle = "<C-o>",
          split = "<C-s>",
          vsplit = "<C-v>",
        },
      },
      outline = {
        layout = "float",
        keys = {
          toggle_or_jump = "o",
        },
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
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
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
      "hrsh7th/cmp-emoji",
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
    dependencies = {
      "folke/neodev.nvim",
      "nvim-neotest/nvim-nio",
    },
    keys = function()
      local function dap() return require("dap") end

      return {
        { "<leader>dd", function() dap().toggle_breakpoint() end },
        { "<leader>dD", function() dap().clear_breakpoints() end },
        { "<leader>dl", function() dap().list_breakpoints() end },
        { "<leader>dn", function() dap().step_over() end },
        { "<leader>di", function() dap().step_into() end },
        { "<leader>do", function() dap().step_out() end },
        { "<leader>dc", function() dap().continue() end },
        { "<leader>dC", function() dap().disconnect() end },
        { "<leader>de", function() dap().set_exception_breakpoints() end },
        { "<leader>dE", function() dap().set_exception_breakpoints({}) end },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    main = "dapui",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = function()
      return {
        { "<leader>du", function() require("dapui").toggle() end }
      }
    end,
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = { virt_text_pos = "eol" },
  },
  {
    "jackMort/ChatGPT.nvim",
    main = "chatgpt",
    cmd = {
      "ChatGPT",
      "ChatGPTActAs",
      "ChatGPTEditWithInstructions",
      "ChatGPTRun",
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      api_key_cmd = "echo " .. gpt_key,
    },
  },
  {
    "windwp/nvim-autopairs",
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
    "hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    priority = 110,
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = { [""] = require("rainbow-delimiters").strategy["global"] },
        query = { [""] = "rainbow-delimiters" },
        priority = { [""] = 110 },
        highlight = require("gradient_gen").scope_color_keys,

      }
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    priority = 100,
    config = function()
      local hooks = require "ibl.hooks"
      require("ibl").setup {
        indent = {
          char = "▏",
          highlight = require("gradient_gen").indent_color_keys,
        },
        scope = {
          highlight = require("gradient_gen").indent_color_keys,
          show_start = false,
        },
      }

      hooks.register(
        hooks.type.SCOPE_HIGHLIGHT,
        hooks.builtin.scope_highlight_from_extmark
      )
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
    cond = enableScrollAnimation,
    event = "VeryLazy",
    opts = { easing = "quadratic" },
    config = function(_, opts)
      local s = require('neoscroll')
      s.setup(opts)

      local m = { 'n', 'v', 'x' }
      Map(m, "<C-u>", function() s.ctrl_u({ duration = 500 }) end)
      Map(m, "<C-d>", function() s.ctrl_d({ duration = 500 }) end)
      Map(m, "<C-b>", function() s.ctrl_b({ duration = 800 }) end)
      Map(m, "<C-f>", function() s.ctrl_f({ duration = 800 }) end)
      Map(m, "<C-y>", function() s.scroll(-0.1, { move_cursor = false, duration = 250 }) end)
      Map(m, "<C-e>", function() s.scroll(0.1, { move_cursor = false, duration = 250 }) end)
      Map(m, "zt", function() s.zt({ half_win_duration = 500 }) end)
      Map(m, "zz", function() s.zz({ half_win_duration = 500 }) end)
      Map(m, "zb", function() s.zb({ half_win_duration = 500 }) end)
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
    "norcalli/nvim-colorizer.lua",
    cmd = {
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
      "ColorizerToggle",
    },
    config = true,
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
      local pick = function() require("nvim-window").pick() end
      return { { "<C-w>f", pick, noremap = false } }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "anuvyklack/windows.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
    event = { "BufReadPre", "BufNewFile" },
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
    opts = {
      open_mapping = { [[<C-\>]], [[<C-¥>]] },
    },
    keys = function()
      local lazy_ins
      local function lazygit()
        if lazy_ins == nil then
          lazy_ins = require("toggleterm.terminal").Terminal:new({
            cmd = "lazygit",
            direction = "float",
            hidden = true,
          })
        end
        return lazy_ins
      end
      return {
        [[<C-\>]],
        [[<C-¥>]],
        { "<leader>lg", function() lazygit():toggle() end },
        { "<S-esc>",    [[<C-\><C-n>]],                   mode = "t" },
        { "<C-w>",      [[<C-\><C-n><C-w>]],              mode = "t" },
      }
    end
  },
  {
    "chentoast/marks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    commit = "d9328ef",
    dependencies = {
      "MunifTanjim/nui.nvim",
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
    -- lsp ui
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "FabijanZulj/blame.nvim",
    cmd = { "BlameToggle" },
    opts = {},
  },
  {
    "Pocco81/auto-save.nvim",
    event = "InsertEnter",
    opts = {
      execution_message = {
        message = function() return "" end,
      }
    },
  },
  {
    "sinnchan/gradient_gen.nvim",
    lazy = false,
    event = "VeryLazy",
    config = true,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      chunk = {
        enable = true,
        style = "Cyan",
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinLeave" },
    opts = {
      hi = { bg = "background" },
      symbols = { "─", "│", "╭", "╮", "╰", "╯" },
    },
  },
}

require("lazy").setup(plugins, lazy_opts)
