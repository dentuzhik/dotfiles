let $BASH_ENV='~/.bashrc'

" General settings
set nocompatible
set noswapfile
set undodir=~/.vim/undodir
set undofile
set nobackup
set noerrorbells
set ttyfast
set lazyredraw

" Content settings
set encoding=utf-8
set fileformat=unix
set fileencoding=utf-8

" Search settings
set incsearch
set showmatch
set hlsearch
set ignorecase
set smartcase

" Indentation settings
set autoindent
set expandtab
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" UI settings
set title
set nowrap
set ruler
set number
set showcmd
set showmode
set wildmenu
set cursorline
set laststatus=2
set colorcolumn=120
set list
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
set scrolloff=5
set sidescrolloff=5

" Required for Vundle initialization
filetype off

" Automatically setting up Vundle, if not installed
let has_plug=1
if !filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    let has_plug=0
    !echo 'Fetching vim-plug into ~/.local/share/nvim/site/autoload/plug.vim'
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    :q
endif

" Stuff, required for Vundle to work
set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')

" Color schemes
Plug 'altercation/vim-colors-solarized'
Plug 'KeitaNakamura/neodark.vim'

" Syntax highlighting plugins
Plug 'othree/html5.vim'
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'elzr/vim-json'
Plug 'tmux-plugins/vim-tmux'
Plug 'digitaltoad/vim-jade'
Plug 'wavded/vim-stylus'
Plug 'neoclide/vim-jsx-improve'
Plug 'mustache/vim-mustache-handlebars'
Plug 'leafgarland/typescript-vim'
Plug 'chr4/nginx.vim'

" IDE-like features
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'DavidEGx/ctrlp-smarttabs'
Plug 'tacahiroy/ctrlp-funky'
Plug 'dyng/ctrlsf.vim'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'shime/vim-livedown'
Plug 'mattn/emmet-vim'
Plug 'k0kubun/vim-open-github'
Plug 'heavenshell/vim-jsdoc'

" Search improvements
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'bronson/vim-visual-star-search'

" Session management plugins
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" Filesystem integrations
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-projectionist'

" Editor enhancements
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'terryma/vim-multiple-cursors'
Plug 'michaeljsmith/vim-indent-object'

" Linting, Autocompletion & Snippets
Plug 'w0rp/ale'
Plug 'ternjs/tern_for_vim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'SirVer/ultisnips'
Plug 'wokalski/autocomplete-flow'
Plug 'othree/jspc.vim'

call plug#end()

filetype plugin indent on
filetype indent on
syntax enable
syntax sync minlines=256
set synmaxcol=256

" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
set termguicolors

" let g:solarized_termcolors=256
" set background=dark
" colorscheme solarized

let g:neodark#background = '#202020'
colorscheme neodark

" incesearch settings
let g:incsearch#auto_nohlsearch = 1

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" incsearch-fuzzy
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" NERDTree settings
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeAutoCenter=1
let NERDTreeChDirMode=2
let NERDTreeAutoDeleteBuffer=1
let NERDTreeAutoCenterThreshold=5
let NERDTreeWinSize=35
:nnoremap <leader>` :NERDTreeFind<CR>

" Settings for CtrlP
let g:ctrlp_working_path_mode = 'ra'
"ctrl+p ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
let g:ctrlp_map = '<c-_>'
let g:ctrlp_extensions = ['smarttabs']
map <leader>t :CtrlPSmartTabs<CR>
map <leader>m :CtrlPModified<CR>

let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_multi_buffers = 1
let g:ctrlp_funky_syntax_highlight = 1
nmap <silent> <C-o> :CtrlPFunky<CR>

" Syntax liniting and automfixing
let g:airline#extensions#ale#enabled = 1

let g:ale_echo_cursor = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {
\   'php': [],
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'scss': ['stylelint']
\}
let g:ale_fixers = {
\   'javascript': ['eslint']
\ }
nmap <leader>F :ALEFix<CR>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
        lopen
    else
        lclose
    endif
endfunction
nnoremap <silent> <leader>e :call ToggleErrors()<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprev<CR>

" Settings for autocompletion (Deoplete & TernJS)
let g:deoplete#enable_at_startup = 1
"
" Start: tern & deoplete-ternjs
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
let g:tern_map_keys = 1

let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#include_keywords = 1

let g:deoplete#sources#ternjs#filetypes = [
\   'jsx',
\   'javascript.jsx',
\ ]
" End: deoplete-ternjs

" Start: deoplete and vim-multiple-cursors
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    if exists('g:deoplete#disable_auto_complete')
       let g:deoplete#disable_auto_complete = 1
    endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
    if exists('g:deoplete#disable_auto_complete')
       let g:deoplete#disable_auto_complete = 0
    endif
endfunction
" End: deoplete and vim-multiple-cursors

" Start: deoplete-flow
" Configuration to prefer local flow (from node_modules) to a globally
" installed version
function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))

if g:flow_path != 'flow not found'
  let g:deoplete#sources#flow#flow_bin = g:flow_path
endif
" End: deoplete-flow

let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
let g:UltiSnipsListSnippets='<leader>u'
let g:UltiSnipsEditSplit='vertical'

" Other plugins settings
let NERDSpaceDelims=1
let g:gitgutter_max_signs=1000

autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Disable w0rp/ale syntax highlight inside ctrlp buffer
autocmd BufEnter ControlP let b:ale_enabled = 0

" Close Vim, if the only window left is NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

autocmd BufRead,BufNewFile .eslintrc set filetype=json
autocmd BufRead,BufNewFile *nginx.conf* set filetype=nginx
autocmd! BufWritePost .vimrc source $MYVIMRC

:nmap <leader>M :LivedownPreview<CR>

iab reuqure require
iab reuire require

:nmap gV `[v`]

:nmap <leader>f <Plug>CtrlSFPrompt
:vmap <leader>f <Plug>CtrlSFVwordExec
:nmap <leader>w <Plug>CtrlSFCCwordPath
:nmap <leader>W <Plug>CtrlSFCwordPath
