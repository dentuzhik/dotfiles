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
let has_vundle=1
if !filereadable(expand('~/.vim/bundle/Vundle.vim/README.md'))
    let has_vundle=0
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

" Stuff, required for Vundle to work
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'

" Syntax highlighting plugins
Plugin 'othree/html5.vim'
Plugin 'othree/yajs.vim'
Plugin 'othree/es.next.syntax.vim'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'elzr/vim-json'

Plugin 'digitaltoad/vim-jade'
Plugin 'wavded/vim-stylus'
Plugin 'mxw/vim-jsx'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'nginx.vim'

Plugin 'michaeljsmith/vim-indent-object'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'sickill/vim-pasta'
Plugin 'sjl/gundo.vim'
Plugin 'shime/vim-livedown'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'

Plugin 'heavenshell/vim-jsdoc'
Plugin 'w0rp/ale'
Plugin 'ternjs/tern_for_vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'mattn/emmet-vim'
Plugin 'othree/jspc.vim'

Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-projectionist'

Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jasoncodes/ctrlp-modified.vim'

Plugin 'mileszs/ack.vim'
Plugin 'dyng/ctrlsf.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'Raimondi/delimitMate'

Plugin 'terryma/vim-multiple-cursors'

Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

call vundle#end()

" Installing Vundle plugins the first time, quits when done
if has_vundle == 0
    :silent! PluginInstall
    :q
endif

filetype plugin indent on
filetype indent on
syntax enable
syntax sync minlines=256
set synmaxcol=256

let g:solarized_termcolors=256
set background=dark
colorscheme solarized

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

map <Leader>m :CtrlPModified<CR>
map <Leader>M :CtrlPBranch<CR>

let g:airline#extensions#ale#enabled = 1
" let g:ale_open_list = 1
let g:ale_echo_cursor = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'scss': ['stylelint']
\}

function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
        lopen
    else
        lclose
    endif
endfunction
nnoremap <silent> <Leader>e :call ToggleErrors()<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprev<CR>

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    if exists(':NeoCompleteLock')==2
        exe 'NeoCompleteLock'
    endif
endfunction

" Called once only when the multiple selection is canceled
" (default <Esc>)
function! Multiple_cursors_after()
    if exists(':NeoCompleteUnlock')==2
        exe 'NeoCompleteUnlock'
    endif
endfunction

" Other plugins settings
let NERDSpaceDelims=1
let delimitMate_balance_matchpairs=1
let g:gitgutter_max_signs=1000

autocmd BufRead,BufNewFile *.mjs set filetype=javascript
autocmd BufRead,BufNewFile .eslintrc set filetype=json
autocmd BufRead,BufNewFile *nginx.conf* set filetype=nginx
autocmd! BufWritePost .vimrc source $MYVIMRC

:nmap <leader>u :GundoToggle<CR>
:nmap <leader>m :LivedownPreview<CR>

:nmap <C-S-Up> [e
:nmap <C-S-Down> ]e

:vmap <C-S-Up> [egv
:vmap <C-S-Down> ]egv

iab reuqure require
iab reuire require

:nmap gV `[v`]

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev ag Ack!
:nnoremap <Leader>a :Ack!<CR>
:vnoremap <Leader>a y:Ack! <C-r>=fnameescape(@")<CR><CR>
