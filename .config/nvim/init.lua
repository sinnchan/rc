--------------------------------------------------
-- INIT.LUA
--------------------------------------------------

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
vim.o.guifont = "ProFont IIx Nerd Font:h12"


local keymap = vim.keymap.set

keymap('n', '<C-l>', '10zl')
keymap('n', '<C-h>', '10zh')
keymap('n', '<leader>h', ':vertical resize -10<CR>')
keymap('n', '<leader>j', ':resize -10<CR>')
keymap('n', '<leader>k', ':resize +10<CR>')
keymap('n', '<leader>l', ':vertical resize +10<CR>')
keymap('n', '<leader>rr', ':source ~/.config/nvim/init.lua<CR>', { silent = true })


local coc_config = function()
  -- Autocomplete
  function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  end

  -- tabでsuggest選択
  local opts = { silent = true, expr = true, replace_keycodes = false }
  keymap("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
    opts)
  keymap("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
  -- 一番上のサジェストをEnterで適用する
  keymap('i', '<CR>', [[coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
    opts)

  opts = { silent = true }
  keymap("n", "g[", "<Plug>(coc-diagnostic-prev)", opts)
  keymap("n", "g]", "<Plug>(coc-diagnostic-next)", opts)

  -- GoTo code navigation
  keymap("n", "gd", "<Plug>(coc-definition)", opts)
  keymap("n", "gy", "<Plug>(coc-type-definition)", opts)
  keymap("n", "gi", "<Plug>(coc-implementation)", opts)
  keymap("n", "gr", "<Plug>(coc-references)", opts)

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

  keymap("n", "K", '<CMD>lua _G.show_docs()<CR>', opts)

  -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
  vim.api.nvim_create_augroup("CocGroup", {})
  vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
  })

  -- Symbol renaming
  keymap("n", "<leader>rn", "<Plug>(coc-rename)", opts)

  -- Formatting selected code
  keymap("x", "<leader>cf", "<Plug>(coc-format-selected)", opts)
  keymap("n", "<leader>cf", "<Plug>(coc-format-selected)", opts)
  keymap('n', '<leader>fa', [[<cmd>call CocAction('format')<CR>]], { noremap = true, silent = true })


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

  -- Apply codeAction to the selected region
  -- Example: `<leader>aap` for current paragraph
  opts = { silent = true, nowait = true }
  keymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
  keymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

  -- Remap keys for apply code actions at the cursor position.
  keymap("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
  -- Remap keys for apply source code actions for current file.
  keymap("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
  -- Apply the most preferred quickfix action on the current line.
  keymap("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

  -- Remap keys for apply refactor code actions.
  opts = { silent = true }
  keymap("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", opts)
  keymap("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", opts)
  keymap("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", opts)

  opts = { silent = true, nowait = true }
  -- Run the Code Lens actions on the current line
  keymap("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

  -- i = inner, a = a, f = function, c = class. を選択する
  -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
  keymap("x", "if", "<Plug>(coc-funcobj-i)", opts)
  keymap("o", "if", "<Plug>(coc-funcobj-i)", opts)
  keymap("x", "af", "<Plug>(coc-funcobj-a)", opts)
  keymap("o", "af", "<Plug>(coc-funcobj-a)", opts)
  keymap("x", "ic", "<Plug>(coc-classobj-i)", opts)
  keymap("o", "ic", "<Plug>(coc-classobj-i)", opts)
  keymap("x", "ac", "<Plug>(coc-classobj-a)", opts)
  keymap("o", "ac", "<Plug>(coc-classobj-a)", opts)

  -- Remap <C-f> and <C-b> to scroll float windows/popups
  ---@diagnostic disable-next-line: redefined-local
  opts = { silent = true, nowait = true, expr = true }
  keymap("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  keymap("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
  keymap("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
  keymap("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
  keymap("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  keymap("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

  -- Use CTRL-S for selections ranges
  -- Requires 'textDocument/selectionRange' support of language server
  opts = { silent = true }
  keymap("n", "<C-s>", "<Plug>(coc-range-select)", opts)
  keymap("x", "<C-s>", "<Plug>(coc-range-select)", opts)

  opts = { silent = true, nowait = true }
  keymap("n", "<leader>ca", ":<C-u>CocList diagnostics<cr>", opts)
  keymap("n", "<leader>ce", ":<C-u>CocList extensions<cr>", opts)
  keymap("n", "<leader>cc", ":<C-u>CocList commands<cr>", opts)
  keymap("n", "<leader>co", ":<C-u>CocList outline<cr>", opts)
  keymap("n", "<leader>cs", ":<C-u>CocList -I symbols<cr>", opts)
  keymap("n", "<leader>cj", ":<C-u>CocNext<cr>", opts)
  keymap("n", "<leader>ck", ":<C-u>CocPrev<cr>", opts)
  keymap("n", "<leader>cp", ":<C-u>CocListResume<cr>", opts)
end

local noise_config = function()
  require("noice").setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true,         -- use a classic bottom cmdline for search
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
  })
end


local telescope_config = function()
  local ts_builtin = require('telescope.builtin')
  keymap('n', '<leader>ff', ts_builtin.find_files, {})
  keymap('n', '<leader>fg', ts_builtin.live_grep, {})
  keymap('n', '<leader>fb', ts_builtin.buffers, {})
  keymap('n', '<leader>fc', ts_builtin.commands, {})
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
  keymap('n', '<leader>to', nt_api.tree.open)
  keymap('n', '<leader>tc', nt_api.tree.close)
  keymap('n', '<leader>tt', nt_api.tree.toggle)
  keymap('n', '<leader>tg', nt_api.tree.focus)
  keymap('n', '<leader>tf', nt_api.tree.find_file)
  keymap('n', '<leader>tr', nt_api.tree.reload)
end

local smooth_scroll_config = function()
  require('neoscroll').setup({
    easing_function = 'cubic' -- cubic, quartic, circular
  })

  require('neoscroll.config').set_mappings({
    ['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '80', nil } },
    ['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '80', nil } },
    ['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100', nil } },
    ['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '100', nil } },
    ['<C-y>'] = { 'scroll', { '-0.10', 'false', '50', nil } },
    ['<C-e>'] = { 'scroll', { '0.10', 'false', '50', nil } },
    ['zt'] = { 'zt', { '300' } },
    ['zz'] = { 'zz', { '300' } },
    ['zb'] = { 'zb', { '300' } },
  })
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
    use 'reisub0/hot-reload.vim'
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup { show_end_of_line = true }
      end
    }
    use {
      'navarasu/onedark.nvim',
      config = function() require('onedark').load() end
    }
    use {
      'karb94/neoscroll.nvim',
      config = smooth_scroll_config,
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
      config = function()
        require('ccc').setup({
          highlighter = {
            auto_enable = true,
            lsp = true,
          }
        })
      end
    }
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
      config = function()
        require('lualine').setup { options = { theme = 'onedark' } }
      end
    }
    use {
      'junegunn/fzf.vim',
      run = function() vim.fn['fzf#install()'](0) end,
    }
    use {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      requires = { { 'nvim-lua/plenary.nvim' } },
      config = telescope_config,
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.fn[':TSUpdate'](0) end,
      config = treesitter_config,
      requires = 'nvim-treesitter/playground',
    }
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = tree_config,
    }
    use {
      'neoclide/coc.nvim',
      branch = 'release',
      config = coc_config,
    }
    use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup() end,
    }
    use {
      'folke/noice.nvim',
      event = 'BufRead',
      config = noise_config,
      requires = {
        { 'MunifTanjim/nui.nvim' },
        { 'rcarriga/nvim-notify' }
      }
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end
)
