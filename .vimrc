" view
set number " 行の数字を表示
set showmatch " 対応する括弧を強調表示
set title " タイトルを表示
" tab
set expandtab " タブの代わりにスペース
set shiftwidth=4 " インデントを2
set signcolumn=yes " 画面左端にサイン列を常に表示
set smartindent " 自動インデント
set tabstop=4 " tabを4
autocmd BufRead *.md set tabstop=2 " .mdはインデント2
autocmd BufRead *.md set shiftwidth=2 " .mdはインデント2
" search
set hlsearch " 検索結果をハイライト表示
set incsearch " インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set nofoldenable " 検索にマッチした行以外を折りたたむ(フォールドする)機能
set smartcase " 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan " 最後尾まで検索を終えたら次の検索で先頭に移る
syntax on " シンタックスハイライト
" file
set autoread "外部でファイルに変更がされた場合は読みなおす
set confirm " 保存されていないファイルがあるときは終了前に保存確認
set hidden " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set nobackup " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない
" move
set backspace=indent,eol,start " macはこれがないとBackspaceが聞かない
set imdisable " insertをぬけるとIMEを無効
set mouse=a " バッファスクロール
set virtualedit=block " 文字のないところにカーソル移動できるようにする
" util
set wildmenu wildmode=list:longest,full " command modeでTABでファイル名補完

" COLOR SCHEME
set background=dark
let g:onedark_termcolors=16
syntax on
colorscheme onedark 

" binary mode
"" .binをバイナリモードで開く
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END
"" -bでひらくとxxdで開く
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

" MAPPING
"" cr
nnoremap <S-k> i<CR><Esc>
"" window
nnoremap <C-h> 10h
nnoremap <C-j> 10j
nnoremap <C-k> 10k
nnoremap <C-l> 10l
nnoremap <Space>h :vertical resize -1<CR>
nnoremap <Space>j :resize -1<CR>
nnoremap <Space>k :resize +1<CR>
nnoremap <Space>l :vertical resize +1<CR>

