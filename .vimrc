" view
set number " 行の数字を表示
set showmatch " 対応する括弧を強調表示
set title " タイトルを表示

" tab
set expandtab " タブの代わりにスペース
set shiftwidth=4 " インデントを2
set signcolumn=yes " 画面左端にサイン列を常に表示
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
set encoding=utf-8
set autoread "外部でファイルに変更がされた場合は読みなおす
set confirm " 保存されていないファイルがあるときは終了前に保存確認
set hidden " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set nobackup " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない
set nowritebackup

" move
set backspace=indent,eol,start " macはこれがないとBackspaceが聞かない
set imdisable " insertをぬけるとIMEを無効
set mouse=a " バッファスクロール
set virtualedit=block " 文字のないところにカーソル移動できるようにする

" util
set wildmenu wildmode=list:longest,full " command modeでTABでファイル名補完

nnoremap <Space>h :vertical resize -1<CR>
nnoremap <Space>j :resize -1<CR>
nnoremap <Space>k :resize +1<CR>
nnoremap <Space>l :vertical resize +1<CR>

