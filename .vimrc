let $BASH_ENV='~/.bashrc'

" General settings
set nocompatible
set noswapfile
set undodir=~/.vim/undodir
set undofile
set nobackup
set noerrorbells
set mouse=a

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

set ttyfast
set lazyredraw

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
" Plug 'altercation/vim-colors-solarized'
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
Plug 'neoclide/jsonc.vim'
Plug 'tpope/vim-markdown'

" IDE-like features
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'DavidEGx/ctrlp-smarttabs'
Plug 'tacahiroy/ctrlp-funky'
Plug 'dyng/ctrlsf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'k0kubun/vim-open-github'
Plug 'rizzatti/dash.vim'
Plug 'easymotion/vim-easymotion'
Plug 'skywind3000/asyncrun.vim'
Plug 'neoclide/npm.nvim', {'do' : 'npm install'}
Plug 'yardnsm/vim-import-cost', { 'do': 'npm install' }
" Plug 'junkblocker/patchreview-vim'
" Plug 'codegram/vim-codereview'
" Plug 'heavenshell/vim-jsdoc'
Plug 'shime/vim-livedown'

" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'Shougo/denite.nvim'

" Search improvements
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'bronson/vim-visual-star-search'

" Session management plugins
" Plug 'tpope/vim-obsession'
" Plug 'dhruvasagar/vim-prosession'

" Filesystem integrations
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-projectionist'

" Editor enhancements
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdcommenter'
" Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'terryma/vim-multiple-cursors'
Plug 'michaeljsmith/vim-indent-object'
Plug 'machakann/vim-highlightedyank'

" Linting, Autocompletion & Snippets
Plug 'w0rp/ale'

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif

Plug 'SirVer/ultisnips'
" Plug 'othree/jspc.vim'

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

" Start: PLUGINS SETTINGS

" Start: tpope/vim-markdown
let g:markdown_fenced_languages = ['html', 'css', 'javascript', 'js=javascript', 'typescript', 'bash=sh', 'python']
" End: tpope/vim-markdown

" Start: haya14busa/incsearch.vim
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
" End: haya14busa/incsearch.vim

" Start: haya14busa/incsearch-fuzzy.vim
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
" End: haya14busa/incsearch-fuzzy.vim

" Start: scrooloose/nerdtree
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeAutoCenter=1
let NERDTreeChDirMode=2
let NERDTreeAutoDeleteBuffer=1
let NERDTreeAutoCenterThreshold=5
let NERDTreeWinSize=35

" Close Vim, if the only window left is NERDTree
" autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

:nnoremap <leader>` :call NERDTreeFindIfClosed()<CR>
function! NERDTreeFindIfClosed()
    if exists("g:NERDTree") && g:NERDTree.IsOpen()
        NERDTreeClose
    else
        NERDTreeFind
    endif
endfunction
" End: scrooloose/nerdtree

" Start: scrooloose/nerdcommenter
let g:NERDDefaultAlign = 'left'
let NERDSpaceDelims=1
let g:NERDCustomDelimiters={
\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
\}
" End: scrooloose/nerdcommenter

" Start: machakann/vim-highlightedyank
let g:highlightedyank_highlight_duration = 2000
" End: machakann/vim-highlightedyank

" Start: ctrlpvim/ctrlp.vim
let g:ctrlp_working_path_mode = 'ra'
" ctrl+p ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0

" Disable w0rp/ale syntax highlight inside ctrlp buffer
autocmd BufEnter ControlP let b:ale_enabled = 0
" End: ctrlpvim/ctrlp.vim

" Start: DavidEGx/ctrlp-smarttabs
let g:ctrlp_extensions = ['smarttabs']
let g:ctrlp_smarttabs_modify_tabline = 0
nmap <silent> <C-i> :CtrlPSmartTabs<CR>
" End: DavidEGx/ctrlp-smarttabs

" Start: jasoncodes/ctrlp-modified.vim
nmap <silent> <leader>m :CtrlPModified<CR>
" End: jasoncodes/ctrlp-modified.vim

" Start: tacahiroy/ctrlp-funky
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_multi_buffers = 1
let g:ctrlp_funky_syntax_highlight = 1
nmap <silent> <C-o> :CtrlPFunky<CR>
" End: tacahiroy/ctrlp-funky

" Start: vim-airline/vim-airline
let g:airline#extensions#ale#enabled = 1

" let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
" let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
" let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
" End: vim-airline/vim-airline

" Start: w0rp/ale
let g:ale_echo_cursor = 1
let g:ale_fix_on_save = 0
let g:ale_completion_enabled = 1
let g:ale_linters = {
\   'php': [],
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'scss': ['stylelint']
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'json': ['prettier']
\ }
nmap <leader>F :ALEFix<CR>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Not related to w0rp/ale, but since ale puts errors in location list it is
" very handly to use this key binding
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
" Start: w0rp/ale

" Start: rizzatti/dash.vim
:nmap <silent> <leader>d <Plug>DashSearch
:vmap <silent> <leader>d <Plug>DashSearch
:nmap <silent> <leader>D <Plug>DashGlobalSearch
:vmap <silent> <leader>D <Plug>DashGlobalSearch
let g:dash_map = {
\ 'javascript' : ['rweb:'],
\ }
" End: rizzatti/dash.vim

" Start: Shougo/deoplete.nvim
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#min_patter_length = 3
" End: Shougo/deoplete.nvim

" Start: Shougo/denite.nvim
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
" End: Shougo/denite.nvim

" Start: terryma/vim-multiple-cursors,Shougo/denite.nvim
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    if exists('g:deoplete#disable_auto_complete')
       let g:deoplete#disable_auto_complete = 1
    endif

    if exists('g:coc_enabled')
        " :execute "CocDisable"
        :silent exec "CocDisable"
        let g:coc_disabled = 1
    endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
    if exists('g:deoplete#disable_auto_complete')
       let g:deoplete#disable_auto_complete = 0
    endif

    if exists('g:coc_disabled')
        " :execute "CocEnable"
        :silent exec "CocEnable"
    endif
endfunction
" End: terryma/vim-multiple-cursors,Shougo/denite.nvim

" Start: junegunn/goyo.vim
let g:goyo_width=120
let g:goyo_height=90
let g:goyo_linenr=1
nnoremap <silent> <leader>g :Goyo<CR>

function! s:goyo_enter()
  " silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set mouse=a
  " set noshowmode
  " set noshowcmd
  set scrolloff=100

  " Remove artifacts for NeoVim on true colors transparent background.
  " guifg is the terminal's background color (b/c of translucence).
  " https://github.com/junegunn/goyo.vim/issues/156#issuecomment-328386711
  hi! VertSplit    gui=NONE guifg=#1a1d24 guibg=NONE
  hi! StatusLine   gui=NONE guifg=#1a1d24 guibg=NONE
  hi! StatusLineNC gui=NONE guifg=#1a1d24 guibg=NONE
  hi! EndOfBuffer  gui=NONE guifg=#1a1d24 guibg=NONE
endfunction

function! s:goyo_leave()
  " silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  " set showmode
  " set showcmd
  set scrolloff=5

   " Recover original colorscheme highlightings (deep-space)
  hi! VertSplit    gui=NONE    guifg=#51617d guibg=#1b202a
  hi! StatusLine   gui=NONE    guifg=#9aa7bd guibg=#323c4d
  hi! StatusLineNC gui=reverse guifg=#232936 guibg=#51617d
  hi! link         EndOfBuffer NonText
endfunction

au! User GoyoEnter
au  User GoyoEnter nested call <SID>goyo_enter()
au! User GoyoLeave
au  User GoyoLeave nested call <SID>goyo_leave()
" End: junegunn/goyo.vim

" Start: SirVer/ultisnips
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
let g:UltiSnipsListSnippets='<leader>U'
let g:UltiSnipsEditSplit='vertical'
" End: SirVer/ultisnips

" Start: dyng/ctrlsf.vim
:nmap <leader>f <Plug>CtrlSFPrompt
:vmap <leader>f <Plug>CtrlSFVwordExec
:nmap <leader>w <Plug>CtrlSFCCwordPath
:nmap <leader>W <Plug>CtrlSFCwordPath
" End: dyng/ctrlsf.vim

" Start: skywind3000/asyncrun.vim
let g:asyncrun_encs = 'gbk'

nmap <silent> <leader>A :AsyncRun -cwd=<root><Space>
nmap <silent> <leader>a :AsyncRun! -cwd=<root><Space>

augroup vimrc
    autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(30, 1)
    autocmd User AsyncRunStop call asyncrun#quickfix_toggle(30, 1)
augroup END
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

nmap <silent> <leader>i :call asyncrun#quickfix_toggle(30)<CR>
" End: skywind3000/asyncrun.vim

" Start: shime/vim-livedown
:nmap <leader>M :LivedownPreview<CR>
" End: shime/vim-livedown

" Start: airblade/vim-gitgutter
let g:gitgutter_max_signs=1000
" End: airblade/vim-gitgutter

" Start: alvan/vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.md'
let g:closetag_filetypes = '*.html,*.xhtml,*.phtml,*.js'

let g:closetag_xhtml_filenames = '*.xhtml,*.js'
let g:closetag_xhtml_filetypes = 'html,xhtml,phtml,javascript'
" End: alvan/vim-closetag

" Start: jiangmiao/auto-pairs
let g:AutoPairsShortcutJump = '<C-e>'
" End: jiangmiao/auto-pairs

" End: PLUGINS SETTINGS

" Start: AUTOCMDs

" Autosave only when there is something to save. Always saving makes build
" autocmd FocusLost,BufLeave,TabLeave,WinLeave * update

autocmd BufRead,BufNewFile .eslintrc,.babelrc set filetype=json
autocmd BufRead,BufNewFile *nginx.conf* set filetype=nginx
" autocmd! BufWritePost .vimrc source $MYVIMRC

" End: AUTOCMDs

" Start: REMAPPINGS

" Reselect visual block after indent/outdent. Allow ident/outdent multiple times
:vnoremap < <gv
:vnoremap > >gv
nmap gV `[v`]

nmap <silent> <C-h> :tabprev<CR>
nmap <silent> <C-l> :tabnext<CR>

" End: REMAPPINGS

ab reuqure require
ab reuire require
ab lenght length

if exists("+showtabline")
    " Rename tabs to show tab number.
    " (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
    function! MyTabLine()
        let s = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')

            let s .= (i == t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= ' ' . i . ' '
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')

            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, '&buftype')

            if buftype == 'help'
                let file = 'help:' . fnamemodify(file, ':t:r')

            elseif buftype == 'quickfix'
                let file = 'quickfix'

            elseif buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif

            else
                let file = pathshorten(fnamemodify(file, ':p:~:.:r'))
                if getbufvar(bufnr, '&modified')
                    let file = '+' . file
                endif

            endif

            if file == ''
                let file = '[No Name]'
            endif

            let s .= ' ' . file

            let nwins = tabpagewinnr(i, '$')
            if nwins > 1
                let modified = ''
                for b in buflist
                    if getbufvar(b, '&modified') && b != bufnr
                        let modified = '*'
                        break
                    endif
                endfor
                let hl = (i == t ? '%#WinNumSel#' : '%#WinNum#')
                let nohl = (i == t ? '%#TabLineSel#' : '%#TabLine#')
                let s .= ' ' . modified . '(' . hl . winnr . nohl . '/' . nwins . ')'
            endif

            if i < tabpagenr('$')
                let s .= ' %#TabLine#|'
            else
                let s .= ' '
            endif

            let i = i + 1

        endwhile

        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s

    endfunction

    highlight! TabNum term=bold,reverse cterm=bold,reverse ctermfg=1 ctermbg=7 gui=bold
    highlight! TabNumSel term=bold,reverse cterm=bold,reverse ctermfg=1 ctermbg=7 gui=bold,reverse guifg=LightGrey guibg=Black
    highlight! WinNum term=bold,underline cterm=bold,underline ctermfg=11 ctermbg=7 guifg=DarkBlue guibg=LightGrey
    highlight! WinNumSel term=bold cterm=bold ctermfg=7 ctermbg=14 guifg=DarkBlue guibg=LightGrey

    set tabline=%!MyTabLine()
endif
