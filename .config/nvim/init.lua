--------------------------------------------------
-- INIT.LUA
--------------------------------------------------

local keymap = vim.api.nvim_set_keymap

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.confirm = true
vim.opt.encoding = 'utf-8'
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.imdisable = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.title = true
vim.opt.updatetime = 300
vim.opt.wrapscan = false
vim.opt.writebackup = false
vim.opt.colorcolumn = "80"

vim.g.mapleader = " "
vim.o.guifont = "ProFont IIx Nerd Font:h12"

keymap('n', '<leader>h', ':vertical resize -10<CR>', { noremap = true })
keymap('n', '<leader>j', ':resize -10<CR>', { noremap = true })
keymap('n', '<leader>k', ':resize +10<CR>', { noremap = true })
keymap('n', '<leader>l', ':vertical resize +10<CR>', { noremap = true })


--------------------------------------------------
-- PACKER
--------------------------------------------------
-- https://github.com/wbthomason/packer.nvim
--
local packer = require('packer')
local lualine = require('lualine')
local tree_sitter_config = require('nvim-treesitter.configs')

---- theme
-- onedark
local onedark = require('onedark')
onedark.load()
-- grovbox
-- vim.o.background = 'dark' -- or 'light'
-- vim.cmd [[colorscheme gruvbox]]
-- lualine
lualine.setup {
  options = { theme = 'onedark' } -- or 'gruvbox_dark'
}

--------------------------------------------------
-- COC NVIM
--------------------------------------------------

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- tabでsuggest選択
local sugOpts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', sugOpts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], sugOpts)
-- 一番上のサジェストをEnterで適用する
keymap('i', '<CR>', [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
  { expr = true, noremap = true })

keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, noremap = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, noremap = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

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

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Formatting selected code
keyset("x", "<leader>cf", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>cf", "<Plug>(coc-format-selected)", { silent = true })
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
local caOpts = { silent = true, nowait = true }
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", caOpts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", caOpts)

-- Remap keys for apply code actions at the cursor position.
keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", caOpts)
-- Remap keys for apply source code actions for current file.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", caOpts)
-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", caOpts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", caOpts)

-- i = inner, a = a, f = function, c = class. を選択する
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", caOpts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", caOpts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", caOpts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", caOpts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", caOpts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", caOpts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", caOpts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", caOpts)

-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local scOpts = { silent = true, nowait = true, expr = true }
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scOpts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scOpts)
keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', scOpts)
keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', scOpts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scOpts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scOpts)

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })


keyset("n", "<leader>ca", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true })
-- Manage extensions
keyset("n", "<leader>ce", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true })
-- Show commands
keyset("n", "<leader>cc", ":<C-u>CocList commands<cr>", { silent = true, nowait = true })
-- Find symbol of current document
keyset("n", "<leader>co", ":<C-u>CocList outline<cr>", { silent = true, nowait = true })
-- Search workleader symbols
keyset("n", "<leader>cs", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true })
-- Do default action for next item
keyset("n", "<leader>cj", ":<C-u>CocNext<cr>", { silent = true, nowait = true })
-- Do default action for previous item
keyset("n", "<leader>ck", ":<C-u>CocPrev<cr>", { silent = true, nowait = true })
-- Resume latest coc list
keyset("n", "<leader>cp", ":<C-u>CocListResume<cr>", { silent = true, nowait = true })

--------------------------------------------------
-- FZF
--------------------------------------------------

local ts_builtin = require('telescope.builtin')
keyset('n', '<leader>ff', ts_builtin.find_files, {})
keyset('n', '<leader>fg', ts_builtin.live_grep, {})
keyset('n', '<leader>fb', ts_builtin.buffers, {})
keyset('n', '<leader>fc', ts_builtin.commands, {})

local ts = require('telescope')
ts.setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
ts.load_extension('fzf')


--------------------------------------------------
-- GIT SIGNS
--------------------------------------------------

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
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
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

--------------------------------------------------
-- TREE-SITTER
--------------------------------------------------

tree_sitter_config.setup {
  ensure_installed = { 'c', 'lua', 'vim', 'dart' },
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}


--------------------------------------------------
-- TREE.NVIM
--------------------------------------------------

local nt = require('nvim-tree')
local nt_api = require('nvim-tree.api')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

nt.setup({
  sort_by = 'case_sensitive',
  view = {
    width = 30,
  },
})

-- key bind
keyset('n', '<leader>to', nt_api.tree.open, { noremap = true })
keyset('n', '<leader>tq', nt_api.tree.close, { noremap = true })
keyset('n', '<leader>tt', nt_api.tree.toggle, { noremap = true })
keyset('n', '<leader>tg', nt_api.tree.focus, { noremap = true })
keyset('n', '<leader>tf', nt_api.tree.find_file, { noremap = true })
keyset('n', '<leader>tr', nt_api.tree.reload, { noremap = true })


--------------------------------------------------
-- SMOOTH SCROLL
--------------------------------------------------

local smooth = require('neoscroll')
smooth.setup({
  easing_function = 'cubic' -- cubic, quartic, circular
})

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

return packer.startup(
  function(use)
    -- https://github.com/wbthomason/packer.nvim
    use 'wbthomason/packer.nvim'
    -- https://github.com/nvim-lualine/lualine.nvim
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    ---- theme
    -- https://github.com/navarasu/onedark.nvim
    use 'navarasu/onedark.nvim'
    -- https://github.com/ellisonleao/gruvbox.nvim
    use 'ellisonleao/gruvbox.nvim'
    -- https://github.com/junegunn/fzf.vim
    use {
      'junegunn/fzf.vim',
      run = function() vim.fn['fzf#install()'](0) end
    }
    -- fzf preview
    -- https://github.com/nvim-telescope/telescope.nvim
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.2',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
    -- https://github.com/nvim-treesitter/nvim-treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.fn[':TSUpdate'](0) end
    }
    -- https://github.com/nvim-tree/nvim-tree.lua
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
    }
    -- https://github.com/karb94/neoscroll.nvim
    use 'karb94/neoscroll.nvim'

    -- lewis6991/gitsigns.nvim
    use 'lewis6991/gitsigns.nvim'

    -- https://github.com/neoclide/coc.nvim
    use {
      'neoclide/coc.nvim',
      branch = 'release',
    }

    -- https://github.com/windwp/nvim-autopairs
    use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
    }

    if packer_bootstrap then
      packer.sync()
    end
  end
)
