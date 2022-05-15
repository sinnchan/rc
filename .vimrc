" 行の数字を表示
set number
" tabをspace４文字分にする
set tabstop=4
set shiftwidth=4
set expandtab
" 検索にマッチした行以外を折りたたむ(フォールドする)機能
set nofoldenable
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索結果をハイライト表示
set hlsearch
" 対応する括弧を強調表示
set showmatch
" シンタックスハイライト
syntax on
" バッファスクロール
set mouse=a
" insertをぬけるとIMEを無効
set imdisable
set notitle

" MAPPING
"" hilight
map <Esc><Esc> :noh<CR>
"" cursor
nnoremap <Space>i ^
nnoremap <Space>a $
"" tab
nnoremap <S-h> gT
nnoremap <S-l> gt
"" cr
nnoremap <S-k> i<CR><Esc>
"" window
nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l
nnoremap <C-h> :vertical resize -1<CR>
nnoremap <C-j> :resize -1<CR>
nnoremap <C-k> :resize +1<CR>
nnoremap <C-l> :vertical resize +1<CR>

