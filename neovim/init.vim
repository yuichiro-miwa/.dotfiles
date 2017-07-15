"================================================
"設定
"================================================
set number
set title
set noswapfile

filetype indent on
set tabstop=4
set shiftwidth=2
set expandtab
set list

" insertモードから抜ける
inoremap <silent> jj <ESC>
inoremap <silent> <C-j> j
inoremap <silent> kk <ESC>
inoremap <silent> <C-k> k

" 検索設定
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

" その他の設定
set hidden "複数ファイルの編集を可能にする
set cursorline "カーソルラインを表示する

":findのPATH指定
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" 矢印キーを無効化
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" neovim - terminarl setting
tnoremap <silent> <ESC> <C-\><C-n>

" python3へのpath
let g:python3_host_prog = $PYENV_ROOT . '/usr/local/bin/python3'

"================================================
"dein設定
"================================================

" プラグインがインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif


"================================================
"stylefmt設定
"================================================

nnoremap <silent> <leader>cs :Stylefmt<CR>
vnoremap <silent> <leader>cs :StylefmtVisual<CR>


"================================================
"neosnippet設定
"================================================

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

if expand("%:t") =~ ".*\.scss"
    setlocal iskeyword+=$
    setlocal iskeyword+=-
endif

if expand("%:t") =~ ".*\.css"
    setlocal iskeyword+=-
endif

"================================================
"NERDTree設定
"================================================

"ファイルを指定してviを起動した際はNERDTreeを開かない
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <C-n> :NERDTreeToggle<CR>

"================================================
"linter setting
"================================================

"autocmd! BufWritePost * Neomake " 保存時に実行する

" edlint setting
"let g:neomake_javascript_enabled_makers = ['xo']

" stylelint setting
"let g:syntastic_css_checkers = ['stylefmt']
"let g:syntastic_scss_checkers = ['stylefmt']

" error & warn settingj
"let g:neomake_error_sign = {'text': '>>', 'texthl': 'WarningMsg'}
"let g:neomake_warning_sign = {'text': '>>',  'texthl': 'Question'}


" colorschemeの設定
set background=dark
colorscheme solarized

" vim-easy-alignの設定
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"================================================
"Endtagcomment setting
"================================================

function! Endtagcomment()
    let reg_save = @@

    try
        silent normal vaty
    catch
        execute "normal \<Esc>"
        echohl ErrorMsg
        echo 'no match html tags'
        echohl None
        return
    endtry

    let html = @@

    let start_tag = matchstr(html, '\v(\<.{-}\>)')
    let tag_name  = matchstr(start_tag, '\v([a-zA-Z]+)')

    let id = ''
    let id_match = matchlist(start_tag, '\vid\=["'']([^"'']+)["'']')
    if exists('id_match[1]')
        let id = '#' . id_match[1]
    endif

    let class = ''
    let class_match = matchlist(start_tag, '\vclass\=["'']([^"'']+)["'']')
    if exists('class_match[1]')
        let class = '.' . join(split(class_match[1], '\v\s+'), '.')
    endif

    execute "normal `>va<\<Esc>`<"

    let comment = g:endtagcommentFormat
    let comment = substitute(comment, '%tag_name', tag_name, 'g')
    let comment = substitute(comment, '%id', id, 'g')
    let comment = substitute(comment, '%class', class, 'g')
    let @@ = comment

    normal ""P

    let @@ = reg_save
endfunction

let g:endtagcommentFormat = '<!-- /%tag_name%id%class -->'
nnoremap ,t :<C-u>call Endtagcomment()<CR>
