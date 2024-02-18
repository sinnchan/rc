-----------------
-- vim options --
-----------------

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
vim.opt.encoding = 'utf-8'
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

-- cmd
vim.cmd [[ autocmd FileType markdown,rust setlocal tabstop=2 ]]

-- default vim keymap
Map = vim.keymap.set
Map('n', '<C-l>', '10zl')
Map('n', '<C-h>', '10zh')
Map('n', '<leader>rr', ':source ~/.config/nvim/init.lua<CR>', { silent = true })
Map('n', '<leader>ro', ':e ~/.config/nvim/init.lua<CR>', { silent = true })


-------------
-- configs --
-------------

local coc_config = function()
  -- extensions
  vim.g.coc_global_extensions = {
    'coc-lua',
    'coc-flutter',
    'coc-pairs',
    'coc-json',
    'coc-git',
    'coc-rust-analyzer',
    'coc-xml',
    'coc-sh',
    'coc-kotlin',
    'coc-clangd',
    'coc-sourcekit',
    'coc-vimlsp',
    'coc-go',
  }

  -- Autocomplete
  function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  end

  -- Use K to show documentation in preview window
  function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
      vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
      vim.fn.CocActionAsync('doHover')
    else
      vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
  end

  -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
  vim.api.nvim_create_augroup("CocGroup", {})
  vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
  })

  -- Setup formatexpr specified filetype(s)
  -- フォーマットをCocでハンドリング
  vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
  })

  -- Update signature help on jump placeholder
  vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
  })


  -- function
  local goto_def_vsplit_top = function()
    vim.cmd('split')
    vim.fn['CocAction']('jumpDefinition')
  end
  local goto_def_vsplit_bottom = function()
    vim.cmd('split')
    vim.cmd('wincmd j')
    vim.fn['CocAction']('jumpDefinition')
  end
  local goto_def_vsplit_left = function()
    vim.cmd('vsplit')
    vim.fn['CocAction']('jumpDefinition')
  end
  local goto_def_vsplit_right = function()
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.fn['CocAction']('jumpDefinition')
  end

  -- keymaps
  local opts = { silent = true, expr = true, replace_keycodes = false }
  Map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
  Map("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

  opts = { silent = true, expr = true }
  Map('i', '<CR>', [[coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

  opts = { silent = true }
  Map("n", "<C-s>", "<Plug>(coc-range-select)", opts)
  Map("n", "<leader>fs", "<Plug>(coc-format-selected)", opts)
  Map("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", opts)
  Map("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", opts)
  Map("n", "<leader>rn", "<Plug>(coc-rename)", opts)
  Map("n", "K", '<CMD>lua _G.show_docs()<CR>', opts)
  Map("n", "g[", "<Plug>(coc-diagnostic-prev)", opts)
  Map("n", "g]", "<Plug>(coc-diagnostic-next)", opts)
  Map("n", "gd", "<Plug>(coc-definition)", opts)
  Map("n", "gDh", goto_def_vsplit_left, opts)
  Map("n", "gDj", goto_def_vsplit_bottom, opts)
  Map("n", "gDk", goto_def_vsplit_top, opts)
  Map("n", "gDl", goto_def_vsplit_right, opts)
  Map("n", "gi", "<Plug>(coc-implementation)", opts)
  Map("n", "gy", "<Plug>(coc-type-definition)", opts)
  Map("x", "<C-s>", "<Plug>(coc-range-select)", opts)
  Map("x", "<leader>fs", "<Plug>(coc-format-selected)", opts)
  Map("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", opts)
  Map('n', '<leader>fa', [[<cmd>call CocAction('format')<CR>]], opts)

  opts = { silent = true, nowait = true }
  Map("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
  Map("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
  Map("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
  Map("n", "<leader>cd", ":<C-u>CocList diagnostics<cr>", opts)
  Map("n", "<leader>cc", ":<C-u>CocList commands<cr>", opts)
  Map("n", "<leader>ce", ":<C-u>CocList extensions<cr>", opts)
  Map("n", "<leader>cj", ":<C-u>CocNext<cr>", opts)
  Map("n", "<leader>ck", ":<C-u>CocPrev<cr>", opts)
  Map("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)
  Map("n", "<leader>co", ":<C-u>CocList outline<cr>", opts)
  Map("n", "<leader>cr", ":<C-u>CocListResume<cr>", opts)
  Map("n", "<leader>cs", ":<C-u>CocList -I symbols<cr>", opts)
  Map("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
  Map("o", "ac", "<Plug>(coc-classobj-a)", opts)
  Map("o", "af", "<Plug>(coc-funcobj-a)", opts)
  Map("o", "ic", "<Plug>(coc-classobj-i)", opts)
  Map("o", "if", "<Plug>(coc-funcobj-i)", opts)
  Map("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
  Map("x", "ac", "<Plug>(coc-classobj-a)", opts)
  Map("x", "af", "<Plug>(coc-funcobj-a)", opts)
  Map("x", "ic", "<Plug>(coc-classobj-i)", opts)
  Map("x", "if", "<Plug>(coc-funcobj-i)", opts)

  opts = { silent = true, nowait = true, expr = true }
  Map("n", "<C-p>", 'coc#float#has_scroll() ? coc#float#scroll(0) : ""', opts)
  Map("n", "<C-n>", 'coc#float#has_scroll() ? coc#float#scroll(1) : ""', opts)
end

local nvim_dap_config = function()
  local dap = require('dap')
  dap.adapters.dart = {
    type = 'executable',
    command = 'flutter',
    args = { 'debug_adapter' }
  }
  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch flutter",
      dartSdkPath = "~/fvm/default/bin/cache/dart-sdk/bin/dart",
      flutterSdkPath = "~/fvm/default/bin/flutter",
      program = "${file}",
      cwd = "${workspaceFolder}",
      toolArgs = { "-d 99111FFAZ00D7Z --dart-define FLAVOR=r --dart-define ENV=dev" }
    }
  }

  -- key
  Map('n', '<leader>dd', dap.toggle_breakpoint)
  Map('n', '<leader>dD', dap.clear_breakpoints)
  Map('n', '<leader>dl', dap.list_breakpoints)
  Map('n', '<leader>dn', dap.step_over)
  Map('n', '<leader>di', dap.step_into)
  Map('n', '<leader>do', dap.step_out)
  Map('n', '<leader>dc', dap.continue)
end

local gitsigns_config = function()
  require('gitsigns').setup {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, o)
        o = o or {}
        o.buffer = bufnr
        vim.keymap.set(mode, l, r, o)
      end

      -- Navigation
      map('n', '<leader>h]', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '<leader>h[', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk)
      map('n', '<leader>hr', gs.reset_hunk)
      map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
      map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>ht', gs.toggle_deleted)
      map('n', '<leader>hT', gs.toggle_current_line_blame)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
end

local telescope_config = function()
  local telescope = require('telescope');
  local ts_builtin = require('telescope.builtin')

  telescope.setup({
    extensions = {
      coc = {
        prefer_locations = true,
      }
    }
  })

  telescope.load_extension('textcase')
  telescope.load_extension('emoji')
  telescope.load_extension('coc')

  local opts = {}
  Map('n', '<leader>ff', ts_builtin.find_files, opts)
  Map('n', '<leader>fl', ts_builtin.live_grep, opts)
  Map('n', '<leader>fb', ts_builtin.buffers, opts)
  Map('n', '<leader>fm', ts_builtin.marks, opts)
  Map('n', '<leader>fc', ts_builtin.commands, opts)
  Map('n', '<leader>fg', ts_builtin.git_status, opts)
  Map('n', '<leader>fe', telescope.extensions.emoji.emoji, opts)
  Map('n', 'gr', '<cmd>Telescope coc references<CR>', opts)

  require('textcase').setup {
    pickers = {
      find_files = {
        follow = true
      }
    }
  }

  opts = { desc = 'Telescope' }
  Map('n', '<leader>fC', '<cmd>TextCaseOpenTelescope<CR>', opts)
  Map('v', '<leader>fC', '<cmd>TextCaseOpenTelescope<CR>', opts)
end


local treesitter_config = function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'lua', 'vim', 'dart' },
    sync_install = true,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end

local tree_config = function()
  local nt = require('nvim-tree')
  local nt_api = require('nvim-tree.api')

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.opt.termguicolors = true

  nt.setup({
    sort_by = 'case_sensitive',
    -- view = { width = 40 },
  })

  -- key bind
  Map('n', '<leader>to', nt_api.tree.open)
  Map('n', '<leader>tc', nt_api.tree.close)
  Map('n', '<leader>tt', nt_api.tree.toggle)
  Map('n', '<leader>tg', nt_api.tree.focus)
  Map('n', '<leader>tf', nt_api.tree.find_file)
  Map('n', '<leader>tr', nt_api.tree.reload)
end

local neoscroll_config = function()
  require('neoscroll').setup({
    easing_function = 'quintic',
  })
  local t    = {}
  t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '80' } }
  t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '80' } }
  t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '160' } }
  t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '160' } }
  t['<C-y>'] = { 'scroll', { '-0.10', 'false', '40' } }
  t['<C-e>'] = { 'scroll', { '0.10', 'false', '40' } }
  t['zt']    = { 'zt', { '80' } }
  t['zz']    = { 'zz', { '80' } }
  t['zb']    = { 'zb', { '80' } }
  require('neoscroll.config').set_mappings(t)
end

local onedark_config = function()
  local onedark = require('onedark')
  onedark.setup {
    transparent = true,
  }
  onedark.load()
end

local lualine_config = function()
  require('lualine').setup {
    options = {
      theme = 'onedark',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    }
  }
end

local ccc_config = function()
  require('ccc').setup({
    highlighter = {
      auto_enable = true,
      lsp = true,
    }
  })
end

local eazy_align_config = function()
  local opts = { noremap = false, silent = true }
  Map("x", "ga", "<Plug>(EasyAlign)", opts)
  Map("n", "ga", "<Plug>(EasyAlign)", opts)
end

local indent_config = function()
  require("ibl").setup {
  }
  local highlight = {
    "IndentLineColor",
  }

  local hooks = require "ibl.hooks"
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "IndentLineColor", { fg = "#303336" })
  end)

  require("ibl").setup {
    indent = {
      highlight = highlight,
      char = "▏",
    },
    scope = {
      enabled = false,
    },
  }
end

local winshift_config = function()
  Map("n", "<C-W>m", "<Cmd>WinShift swap<CR>")
  Map("n", "<C-W>M", "<Cmd>WinShift<CR>")
end

local nvim_window_config = function()
  local opts = { noremap = false }
  Map("n", "<C-w>f", require('nvim-window').pick, opts)
end

local windows_config = function()
  require('windows').setup()

  vim.o.winwidth = 10
  vim.o.winminwidth = 10
  vim.o.equalalways = false

  local function cmd(command)
    return table.concat({ '<Cmd>', command, '<CR>' })
  end

  vim.keymap.set('n', '<C-w>z', cmd 'WindowsMaximize')
  vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically')
  vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally')
  vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize')
end

local tabby_config = function()
  require('tabby.tabline').use_preset('tab_only', {
    theme = {
      fill = 'TabLineFill',       -- tabline background
      head = 'TabLine',           -- head element highlight
      current_tab = 'TabLineSel', -- current tab label highlight
      tab = 'TabLine',            -- other tab label highlight
      win = 'TabLine',            -- window highlight
      tail = 'TabLine',           -- tail element highlight
    },
    nerdfont = true,              -- whether use nerdfont
    lualine_theme = 'onedark',    -- lualine theme name
    buf_name = {
      mode = 'unique',
    },
  })
end

local spectre_config = function()
  local spectre = require("spectre")
  spectre.setup()
  -- Toggle Spectre
  Map('n', '<leader>S', spectre.toggle)
  -- Search current word
  Map('v', '<leader>sw', spectre.open_visual)
  -- Search on current file
  Map('v', '<leader>sp', spectre.open_file_search)
end

local toggleterm_config = function()
  require('toggleterm').setup()
  local terminal = require('toggleterm.terminal').Terminal
  local lazygit = terminal:new({
    cmd = 'lazygit',
    direction = 'float',
    hidden = true,
  })

  Map('n', '<leader>lg', function() lazygit:toggle() end)
end

local marks_config = function()
  require('marks').setup()
end

local hop_config = function()
  local hop = require('hop')
  hop.setup({
    keys = 'abcefhjkmnprstuvwxyz.2345678',
    uppercase_labels = true,
    multi_windows = true,
  })
  Map('n', 'f', function() hop.hint_char1({}) end)
end

--------------------------------------------------
-- PACKER.NVIM BOOTSTRAP
--------------------------------------------------
-- install: $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
--
local packer_bootstrap = (
  function()
    local fn = vim.fn
    local packer_path = '/site/pack/packer/start/packer.nvim'
    local install_path = fn.stdpath('data') .. packer_path

    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
      })
      vim.cmd [[packadd packer.nvim]]
      return true
    end

    return false
  end
)()

--------------------------------------------------
-- PACKER STARTUP
--------------------------------------------------

-- require external command
-- [node, ripgrep, code-minimap]

return require('packer').startup(
  function(use)
    use 'wbthomason/packer.nvim'
    use 'sinnchan/hot-reload.vim'

    use {
      'neoclide/coc.nvim',
      branch = 'release',
      config = coc_config,
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.fn[':TSUpdate'](0) end,
      requires = { 'nvim-treesitter/playground' },
      config = treesitter_config,
    }
    use {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      requires = {
        'nvim-lua/plenary.nvim',
        'johmsalas/text-case.nvim',
        'xiyaowong/telescope-emoji.nvim',
        'fannheyward/telescope-coc.nvim',
      },
      config = telescope_config,
    }
    use {
      'mfussenegger/nvim-dap',
      config = nvim_dap_config,
    }
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = tree_config,
    }
    use {
      'navarasu/onedark.nvim',
      config = onedark_config,
    }
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
      config = lualine_config,
    }
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = indent_config,
    }
    use {
      'karb94/neoscroll.nvim',
      config = neoscroll_config,
    }
    use {
      'lewis6991/gitsigns.nvim',
      config = gitsigns_config,
    }
    use {
      'uga-rosa/ccc.nvim',
      config = ccc_config,
    }
    use {
      'junegunn/vim-easy-align',
      config = eazy_align_config
    }
    use {
      'sindrets/winshift.nvim',
      config = winshift_config,
    }
    use {
      'yorickpeterse/nvim-window',
      config = nvim_window_config,
    }
    use {
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
    }
    use {
      "anuvyklack/windows.nvim",
      requires = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim"
      },
      config = windows_config,
    }
    use {
      'nanozuki/tabby.nvim',
      config = tabby_config,
    }
    use {
      'nvim-pack/nvim-spectre',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = spectre_config,
    }
    use {
      'akinsho/toggleterm.nvim',
      tag = '*',
      config = toggleterm_config,
    }
    use {
      'chentoast/marks.nvim',
      config = marks_config,
    }
    use {
      'OmniSharp/omnisharp-vim',
    }
    use {
      'smoka7/hop.nvim',
      tag = '*',
      config = hop_config,
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end
)
