--------------------------------------------------
-- INIT.LUA
--------------------------------------------------

local keymap = vim.keymap.set

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.colorcolumn = "80"
vim.opt.confirm = true
vim.opt.encoding = 'utf-8'
vim.opt.expandtab = true
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
vim.opt.tabstop = 2
vim.opt.title = true
vim.opt.updatetime = 300
vim.opt.wrapscan = false
vim.opt.writebackup = false

vim.g.mapleader = " "
vim.o.guifont = "ProFont IIx Nerd Font:h12"
vim.g.NERDCreateDefaultMappings = 0

keymap('n', '<leader>h', ':vertical resize -10<CR>')
keymap('n', '<leader>j', ':resize -10<CR>')
keymap('n', '<leader>k', ':resize +10<CR>')
keymap('n', '<leader>l', ':vertical resize +10<CR>')
keymap('n', '<leader>rr', ':source ~/.config/nvim/init.lua<CR>', { silent = true })


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

-- Autocomplete
function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- tabでsuggest選択
local opts = { silent = true, expr = true, replace_keycodes = false }
keymap("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keymap("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- 一番上のサジェストをEnterで適用する
keymap('i', '<CR>', [[coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

opts = { silent = true }
keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", opts)
keymap("n", "]g", "<Plug>(coc-diagnostic-next)", opts)

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

--------------------------------------------------
-- FZF
--------------------------------------------------

local ts_builtin = require('telescope.builtin')
keymap('n', '<leader>ff', ts_builtin.find_files, {})
keymap('n', '<leader>fg', ts_builtin.live_grep, {})
keymap('n', '<leader>fb', ts_builtin.buffers, {})
keymap('n', '<leader>fc', ts_builtin.commands, {})

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

    local function map(mode, l, r, o)
      o = o or {}
      o.buffer = bufnr
      vim.keymap.set(mode, l, r, o)
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
keymap('n', '<leader>to', nt_api.tree.open)
keymap('n', '<leader>tc', nt_api.tree.close)
keymap('n', '<leader>tt', nt_api.tree.toggle)
keymap('n', '<leader>tg', nt_api.tree.focus)
keymap('n', '<leader>tf', nt_api.tree.find_file)
keymap('n', '<leader>tr', nt_api.tree.reload)


--------------------------------------------------
-- SMOOTH SCROLL
--------------------------------------------------

local smooth = require('neoscroll')
smooth.setup({
  easing_function = 'cubic' -- cubic, quartic, circular
})

--------------------------------------------------
-- INDENT LINE
--------------------------------------------------

require("indent_blankline").setup {
  show_end_of_line = true,
}

--------------------------------------------------
-- COLOR VIEWER
--------------------------------------------------

require 'colorizer'.setup()


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
    use 'wbthomason/packer.nvim'
    use "lukas-reineke/indent-blankline.nvim"
    use 'navarasu/onedark.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'karb94/neoscroll.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use {
      'junegunn/fzf.vim',
      run = function() vim.fn['fzf#install()'](0) end
    }
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.2',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.fn[':TSUpdate'](0) end
    }
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
    }
    use {
      'neoclide/coc.nvim',
      branch = 'release',
    }
    use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
    }

    if packer_bootstrap then
      packer.sync()
    end
  end
)
