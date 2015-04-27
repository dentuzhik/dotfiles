" General settings
set nocompatible
set noswapfile
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
if !filereadable(expand('~/.vim/bundle/vundle/README.md'))
    let has_vundle=0
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
endif

" Runtime path should include Vundle
set rtp+=~/.vim/bundle/vundle
" Intialize Vundle plugins
call vundle#begin()

" Vundle manages Vundle
Plugin 'gmarik/vundle'

Plugin 'altercation/vim-colors-solarized'

Plugin 'michaeljsmith/vim-indent-object'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'sickill/vim-pasta'
Plugin 'sjl/gundo.vim'

Plugin 'kien/ctrlp.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'

Plugin 'airblade/vim-gitgutter'
Plugin 'Raimondi/delimitMate'

Plugin 'mustache/vim-mustache-handlebars'
Plugin 'digitaltoad/vim-jade'
Plugin 'SevInf/vim-bemhtml'
Plugin 'wavded/vim-stylus'
Plugin 'othree/yajs.vim'
Plugin 'nginx.vim'

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

" Open NERDTree on vim startup
" autocmd vimenter * NERDTree
" Open NERDTree if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

:nnoremap <leader>t :NERDTreeToggle<CR>
:nnoremap <leader>f :NERDTreeFind<CR>

" NERDCommenter settings
let NERDSpaceDelims=1

let delimitMate_balance_matchpairs=1

let g:gitgutter_max_signs=1000

let g:ctrlp_show_hidden=1
let g:ctrlp_lazy_update=1
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn))|node_modules$'

let g:pasta_paste_before_mapping = ',P'
let g:pasta_paste_after_mapping = ',p'

autocmd BufRead,BufNewFile .jshintrc,.jscsrc,.bowerrc,.ember-cli set filetype=json
autocmd BufRead,BufNewFile *nginx.conf* set filetype=nginx
autocmd! BufWritePost .vimrc source $MYVIMRC

:nmap <leader>u :GundoToggle<CR>

:nmap <C-S-Up> [e
:nmap <C-S-Down> ]e

:vmap <C-S-Up> [egv
:vmap <C-S-Down> ]egv

:nmap gV `[v`]
