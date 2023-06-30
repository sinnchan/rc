
----* vimrc *----

-- 行番号
vim.opt.number = true
-- 対応する括弧を強調表示
vim.opt.showmatch = true
-- タイトルを表示
vim.opt.title = true

--- tab ---
-- タブの代わりにスペース
vim.opt.expandtab = true
-- インデント幅
vim.opt.shiftwidth = 2
-- タブ文字のサイズ
vim.opt.tabstop = 2

--- search ---
-- 検索結果をハイライト表示
vim.opt.hlsearch = true
-- インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
vim.opt.incsearch = true
-- 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
vim.opt.smartcase = true
-- 最後尾まで検索を終えたら次の検索で先頭に移る
vim.opt.wrapscan = false

--- file ---
-- エンコード
vim.opt.encoding = "utf-8"
-- 外部でファイルに変更がされた場合は読みなおす
vim.opt.autoread = true
-- 保存されていないファイルがあるときは終了前に保存確認
vim.opt.confirm = true
-- 保存されていないファイルがあるときでも別のファイルを開くことが出来る
vim.opt.hidden = true

-- " move
-- set backspace=indent,eol,start " macはこれがないとBackspaceが聞かない
-- set imdisable " insertをぬけるとIMEを無効
-- set mouse=a " バッファスクロール
-- set virtualedit=block " 文字のないところにカーソル移動できるようにする
-- " util
-- set wildmenu wildmode=list:longest,full " command modeでTABでファイル名補完
-- nnoremap <Space>h :vertical resize -1<CR>
-- nnoremap <Space>j :resize -1<CR>
-- nnoremap <Space>k :resize +1<CR>
-- nnoremap <Space>l :vertical resize +1<CR>


-- packer
-- https://github.com/wbthomason/packer.nvim
--
-- boot strap packaer
-- $ nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
--
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = require('packer')

return packer.startup(function(use)
  -- https://github.com/wbthomason/packer.nvim
  use 'wbthomason/packer.nvim'
  -- https://github.com/navarasu/onedark.nvim
  use 'navarasu/onedark.nvim'

  if packer_bootstrap then
    packer.sync()
  end
end)

