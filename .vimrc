" General settings
set nocompatible
set noswapfile
set nobackup
set noerrorbells
set t_Co=256

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

" Fixing common typos
command W w
command Q q
command WQ wq
command Wq wq

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
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'SevInf/vim-bemhtml'
Plugin 'othree/yajs.vim'
Plugin 'mhinz/vim-startify'

call vundle#end()

" Installing Vundle plugins the first time, quits when done
if has_vundle == 0
    :silent! PluginInstall
    :q
endif

filetype plugin indent on
filetype indent on
syntax enable

let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" NERDTree settings
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1

" NERDCommenter settings
let NERDSpaceDelims=1

" JS libraries settings
let g:used_javascript_libs = 'jquery,lodash,underscore'
