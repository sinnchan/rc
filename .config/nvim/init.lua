----# vimrc
--# 行番号
vim.opt.number = true
--# 対応する括弧を強調表示
vim.opt.showmatch = true
--# タイトルを表示
vim.opt.title = true

----# tab
--# タブの代わりにスペース
vim.opt.expandtab = true
--# インデント幅
vim.opt.shiftwidth = 2
--# タブ文字のサイズ
vim.opt.tabstop = 2

----# search
--# 検索結果をハイライト表示
vim.opt.hlsearch = true
--# インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
vim.opt.incsearch = true
--# 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
vim.opt.smartcase = true
--# 最後尾まで検索を終えたら次の検索で先頭に移る
vim.opt.wrapscan = false

----# file
--# エンコード
vim.opt.encoding = 'utf-8'
--# 外部でファイルに変更がされた場合は読みなおす
vim.opt.autoread = true
--# 保存されていないファイルがあるときは終了前に保存確認
vim.opt.confirm = true
--# 保存されていないファイルがあるときでも別のファイルを開くことが出来る
vim.opt.hidden = true

--# leader
vim.g.mapleader = " "

----# move
--# insertをぬけるとIMEを無効
vim.opt.imdisable = true
vim.api.nvim_set_keymap('n', '<Space>h', ':vertical resize -10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Cpace>j', ':resize -10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Cpace>k', ':resize +10<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Cpace>l', ':vertical resize +10<CR>', { noremap = true })

----# packer
--# https://github.com/wbthomason/packer.nvim
local packer = require('packer')
local lualine = require('lualine')
local tree_sitter_config = require('nvim-treesitter.configs')

----# theme
--# onedark
local onedark = require('onedark')
onedark.load()
--# grovbox
-- vim.o.background = 'dark' -- or 'light'
-- vim.cmd [[colorscheme gruvbox]]
--# lualine
lualine.setup {
  options = { theme = 'onedark' } -- or 'gruvbox_dark'
}

----# fzf
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

----# tree-sitter
tree_sitter_config.setup {
  ensure_installed = { 'c', 'lua', 'vim', 'dart' },
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

----# tree.nvim
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

--# key bind
vim.keymap.set('n', '<leader>tt', nt_api.tree.toggle, { noremap = true })
vim.keymap.set('n', '<leader>tf', nt_api.tree.find_file, { noremap = true })
vim.keymap.set('n', '<leader>tr', nt_api.tree.reload, { noremap = true })

----# smooth scroll
local smooth = require('neoscroll')
smooth.setup({
  easing_function = 'cubic' -- cubic, quartic, circular
})

----# packer.nvim bootstrap
--# install: $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
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

return packer.startup(
  function(use)
    --# https://github.com/wbthomason/packer.nvim
    use 'wbthomason/packer.nvim'
    --# https://github.com/nvim-lualine/lualine.nvim
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    ----# theme
    --# https://github.com/navarasu/onedark.nvim
    use 'navarasu/onedark.nvim'
    --# https://github.com/ellisonleao/gruvbox.nvim
    use 'ellisonleao/gruvbox.nvim'
    --# https://github.com/junegunn/fzf.vim
    use {
      'junegunn/fzf.vim',
      run = function() vim.fn['fzf#install()'](0) end
    }
    --# fzf preview
    --# https://github.com/nvim-telescope/telescope.nvim
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.2',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    --# https://github.com/nvim-telescope/telescope-fzf-native.nvim
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
    --# https://github.com/nvim-treesitter/nvim-treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function() vim.fn[':TSUpdate'](0) end
    } 
    --# https://github.com/nvim-tree/nvim-tree.lua
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
    }
    --# https://github.com/karb94/neoscroll.nvim
    use 'karb94/neoscroll.nvim'

    if packer_bootstrap then
      packer.sync()
    end
  end
)

