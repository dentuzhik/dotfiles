let $BASH_ENV='~/.bashrc'

" General settings
set nocompatible
set noswapfile
set undodir=~/.vim/undodir
set undofile
set nobackup
set noerrorbells
set t_Co=256
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
" Clear the search highlight by pressing ENTER when in Normal mode (Typing commands)
:nnoremap <CR> :nohlsearch<CR>/<BS><CR>

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

Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'

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
Plug 'mileszs/ack.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'tpope/vim-fugitive'
Plug 'shime/vim-livedown'
Plug 'mattn/emmet-vim'
Plug 'sjl/gundo.vim'
Plug 'heavenshell/vim-jsdoc'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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
Plug 'sickill/vim-pasta'

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
Plug 'honza/vim-snippets'
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
set t_ut=
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum
" set termguicolors

let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" let g:one_allow_italics = 1
" set background=dark
" colorscheme one

" NERDTree settings
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeAutoCenter=1
let NERDTreeChDirMode=2
let NERDTreeAutoDeleteBuffer=1
let NERDTreeAutoCenterThreshold=5
let NERDTreeWinSize=35

" Open NERDTree if no files specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

" Close Vim, if the only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

:nnoremap <leader>` :NERDTreeFind<CR>

let g:ctrlp_working_path_mode = 'ra'
" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup --hidden -g ""'
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
let g:ctrlp_map = '<c-_>'
let g:ctrlp_extensions = ['smarttabs']
map <leader>t :CtrlPSmartTabs<CR>
map <leader>m :CtrlPModified<CR>

let g:airline#extensions#ale#enabled = 1
" let g:ale_open_list = 1
let g:ale_echo_cursor = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'scss': ['stylelint']
\}
let g:ale_fixers = {
\   'javascript': ['eslint']
\ }
nmap <leader>F :ALEFix<CR>

autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

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

" Enable deoplete & neosnippet
let g:deoplete#enable_at_startup = 1

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

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-t>"
let g:UltiSnipsJumpBackwardTrigger="<c-g>"

" Other plugins settings
let NERDSpaceDelims=1
let delimitMate_balance_matchpairs=1
let g:gitgutter_max_signs=1000

autocmd BufRead,BufNewFile *.mjs set filetype=javascript
autocmd BufRead,BufNewFile .eslintrc set filetype=json
autocmd BufRead,BufNewFile *nginx.conf* set filetype=nginx
autocmd! BufWritePost .vimrc source $MYVIMRC

:nmap <leader>u :GundoToggle<CR>
:nmap <leader>M :LivedownPreview<CR>

:nnoremap <C-I> [e
:nnoremap <C-K> ]e

:vnoremap <C-I> [egv
:vnoremap <C-K> ]egv

iab reuqure require
iab reuire require

:nmap gV `[v`]

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev ag Ack!
:nnoremap <leader>a :Ack!<CR>
:vnoremap <leader>a y:Ack! <C-r>=fnameescape(@")<CR><CR>

:nmap <leader>f <Pulug>CtrlSFPrompt
:vmap <leader>f <Plug>CtrlSFVwordExec
:nmap <leader>w <Plug>CtrlSFCCwordPath
:nmap <leader>W <Plug>CtrlSFCwordPath
