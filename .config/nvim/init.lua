
--------------------------------------------------
-- INIT.LUA
--------------------------------------------------

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

vim.g.mapleader = " "

vim.api.nvim_set_keymap('n', '<Space>h', ':vertical resize -10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Space>j', ':resize -10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Space>k', ':resize +10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Space>l', ':vertical resize +10<CR>', { noremap = true })


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
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true, noremap = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true, noremap = true})

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

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
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


--------------------------------------------------
-- FZF
--------------------------------------------------

local ts_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', ts_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', ts_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', ts_builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', ts_builtin.commands, {})

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
local gheight = vim.api.nvim_list_uis()[1].height
local gwidth = vim.api.nvim_list_uis()[1].width
local height = math.floor(gheight * 2 / 3)
local width = math.floor(gwidth * 3 / 4)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

nt.setup({
  sort_by = 'case_sensitive',
  view = {
    width = 30,
    float = {
      enable = true,
      open_win_config = {
        height = height,
        width = width,
        row = (gheight - height) * 0.5,
        col = (gwidth - width) * 0.5
      }
    }
  },
})

-- key bind
vim.keymap.set('n', '<leader>tt', nt_api.tree.toggle, { noremap = true })
vim.keymap.set('n', '<leader>tf', nt_api.tree.find_file, { noremap = true })
vim.keymap.set('n', '<leader>tr', nt_api.tree.reload, { noremap = true })

---- smooth scroll
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
    local install_path = fn.stdpath('data')..packer_path

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
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
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

    -- https://github.com/neoclide/coc.nvim
    use {
      'neoclide/coc.nvim',
      branch = 'release',
    }

    if packer_bootstrap then
      packer.sync()
    end
  end
)

