-----------------
-- vim options --
-----------------

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.colorcolumn = "80"
vim.opt.confirm = true
vim.opt.encoding = 'utf-8'
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.hidden = true
vim.opt.hlsearch = true
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
vim.g.NERDCreateDefaultMappings = 0
vim.g.mapleader = " "

-- default vim keymap
Map = vim.keymap.set
Map('n', '<C-l>', '10zl')
Map('n', '<C-h>', '10zh')
Map('n', '<leader>h', ':vertical resize -10<CR>')
Map('n', '<leader>j', ':resize -10<CR>')
Map('n', '<leader>k', ':resize +10<CR>')
Map('n', '<leader>l', ':vertical resize +10<CR>')
Map('n', '<leader>rr', ':source ~/.config/nvim/init.lua<CR>', { silent = true })
Map('n', '<leader>ro', ':e ~/.config/nvim/init.lua<CR>', { silent = true })
vim.cmd [[ autocmd FileType markdown setlocal tabstop=2 ]]


-------------
-- configs --
-------------

local coc_config = function()
  -- extensions
  vim.g.coc_global_extensions = {
    'coc-json',
    'coc-lua',
    'coc-git',
    'coc-flutter',
    'coc-pairs',
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
  Map("n", "gi", "<Plug>(coc-implementation)", opts)
  Map("n", "gr", "<Plug>(coc-references)", opts)
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
  Map("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
  Map("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
  Map("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
  Map("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  Map("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
  Map("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
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
  local ts_builtin = require('telescope.builtin')
  local opts = {}
  Map('n', '<leader>ff', ts_builtin.find_files, opts)
  Map('n', '<leader>fg', ts_builtin.live_grep, opts)
  Map('n', '<leader>fb', ts_builtin.buffers, opts)
  Map('n', '<leader>fc', ts_builtin.commands, opts)

  require('textcase').setup {}
  require('telescope').load_extension('textcase')
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

local smooth_corsor_config = function()
  require('smoothcursor').setup({
    autostart = true,
    cursor = "", -- cursor shape (need nerd font)
    texthl = "SmoothCursor", -- highlight group, default is { bg = nil, fg = "#FFD400" }
    linehl = nil, -- highlight sub-cursor line like 'cursorline', "CursorLine" recommended
    type = "default", -- define cursor movement calculate function, "default" or "exp" (exponential).
    fancy = {
      enable = true, -- enable fancy mode
      head = { cursor = "", texthl = "SmoothCursorAqua", linehl = nil },
      body = {
        { cursor = "", texthl = "SmoothCursorAqua" },
        { cursor = "●", texthl = "SmoothCursorAqua" },
        { cursor = "|", texthl = "SmoothCursorAqua" },
        { cursor = ":", texthl = "SmoothCursorAqua" },
        { cursor = ".", texthl = "SmoothCursorAqua" },
      },
      tail = { cursor = nil, texthl = "SmoothCursor" }
    },
    flyin_effect = nil,        -- "bottom" or "top"
    speed = 25,                -- max is 100 to stick to your current position
    intervals = 35,            -- tick interval
    priority = 100,            -- set marker priority
    timeout = 3000,            -- timout for animation
    threshold = 3,             -- animate if threshold lines jump
    disable_float_win = false, -- disable on float window
    enabled_filetypes = nil,   -- example: { "lua", "vim" }
    disabled_filetypes = nil,  -- this option will be skipped if enabled_filetypes is set. example: { "TelescopePrompt", "NvimTree" }
  })

  vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
    callback = function()
      local current_mode = vim.fn.mode()
      if current_mode == 'n' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#8aa872' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == 'v' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == 'V' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == '�' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == 'i' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#668aab' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      end
    end,
  })
end

local onedark_config = function()
  require('onedark').load()
end

local lualine_config = function()
  require('lualine').setup { options = { theme = 'onedark' } }
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
  require("indent_blankline").setup { show_end_of_line = true }
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

return require('packer').startup(
  function(use)
    use 'wbthomason/packer.nvim'
    use 'sinnchan/hot-reload.vim'

    use {
      "lukas-reineke/indent-blankline.nvim",
      config = indent_config,
    }
    use {
      'navarasu/onedark.nvim',
      config = onedark_config,
    }
    use {
      'karb94/neoscroll.nvim',
      -- config = smooth_scroll_config,
    }
    use {
      'gen740/SmoothCursor.nvim',
      config = smooth_corsor_config,
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
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
      config = lualine_config,
    }
    use {
      'junegunn/fzf.vim',
      run = function() vim.fn['fzf#install()'](0) end,
    }
    use {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      requires = {
        'nvim-lua/plenary.nvim',
        'johmsalas/text-case.nvim',
      },
      config = telescope_config,
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.fn[':TSUpdate'](0) end,
      requires = { 'nvim-treesitter/playground' },
      config = treesitter_config,
    }
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = tree_config,
    }
    use {
      'junegunn/vim-easy-align',
      config = eazy_align_config
    }
    use {
      'neoclide/coc.nvim',
      branch = 'release',
      config = coc_config,
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end
)
