" General settings
set nocompatible
set noswapfile
set nobackup
set noerrorbells
set t_Co=256

filetype plugin indent on
filetype indent on
syntax enable

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

