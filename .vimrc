" Make Vim more useful
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set nocompatible
" For Pathogen
runtime bundle/vim-pathogen.vim/autoload/pathogen.vim
execute pathogen#infect()
" Enable file type detection and plugins
filetype plugin on
" Enable syntax highlighting
syntax enable
" set default background
set background=light
" toggle background color
nnoremap <leader>b :let &background = ( &background == "dark"? "light" : "dark" )<CR>
" set color scheme
colorscheme solarized

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
set wildmode=list:longest
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
"set noeol
"set binary
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
endif
" persistent undo
"set undofile
"maximum number of changes that can be undone
"set undolevels=1000
"maximum number lines to save for undo on a buffer reload
"set undoreload=10000
" Respect modeline in files
" set modeline
" set modelines=4
set modelines=0
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Highlight current line
set cursorline
" Make tabs as wide as 2 spaces, use spaces instead of tab char
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" autoindent
set autoindent
" Toggle autoindent
nmap <leader>ai :set invai ai?<CR>
" toggle paste mode
set pastetoggle=<f2>
" Toggle paste mode
" (prefer this over 'pastetoggle' to echo current state)
nmap <leader>p :setlocal paste! paste?<CR>
" visual bell
set visualbell
" Highlight searches
set hlsearch
" Ignore case of search
set ignorecase
set smartcase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
"set mouse=a
set mouse=
" Disable error bells
" set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title 
set titlestring=vim:\ %F 
" Set title back to normal on exit of vim
set titleold="" 
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3
set wrap linebreak nolist
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

" clear search highlights
nnoremap <leader><space> :noh<CR>
" match bracket pairs
nnoremap <tab> %
vnoremap <tab> %
" make saving easier
nmap <leader>w :w!<CR>
" strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" Scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
"quicker escaping from insert mode
inoremap jj <ESC>
" moving around split windows easier
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Center screen around cursor with SPACE
nmap <space> zz
" re-hardwrap paragraphs
nnoremap <leader>q gqip
" NERDTree toggle
map <leader>f :let NERDTreeQuitOnOpen = 1<bar>NERDTreeToggle<CR>
map <leader>F :let NERDTreeQuitOnOpen = 0<bar>NERDTreeToggle<CR>

" Ack
" let g:ackprg="<custom-ack-path-goes-here> -H --nocolor --nogroup --column"
" Ack shortcut
nnoremap <leader>a :Ack

" http://vimdoc.sourceforge.net/htmldoc/diff.html#:DiffOrig
" DiffOrig, when the prompt comes up you hit 'recover', and then type :DiffOrig.
" Then when you're done you save the buffer. Then to delete the swap file
" (because it'll still linger and bug you next time), you just type :e,
" which brings up the prompt again, and you can hit 'delete'
" http://stackoverflow.com/questions/63104/smarter-vim-recovery
" command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" http://stackoverflow.com/questions/6426154/taking-a-quick-look-at-difforig-then-switching-back
command! DiffOrig let g:diffline = line('.') | vert new | set bt=nofile | r # | 0d_ | diffthis | :exe "norm! ".g:diffline."G" | wincmd p | diffthis | wincmd p
map <Leader>do :DiffOrig<CR>
map <leader>dc :q<CR>:diffoff!<CR>:e<CR>

"toggle line numbers
nnoremap <leader>n :set invnumber<CR>
nnoremap <leader>nn :set invrelativenumber<CR>
"toggle invisible characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
nnoremap <leader>i :set invlist<CR>

" Session option management
" NOTE: I used to turn options off, but it causes issues with syntax highlighting
" when sourcing session files in session.vim.  So I updated session.vim to source the vimrc on VimEnter.
" If this becomes an issue, see this thread for another possible solution:
" http://stackoverflow.com/questions/5142099/auto-save-vim-session-on-quit-and-auto-reload-session-on-start/6052704#6052704
" set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

" quick access to edit vimrc
nnoremap <leader>ev :vertical topleft split  $MYVIMRC<CR>

"autocommands
if has("autocmd")
  "Auto source(reload) vimrc on save... be careful with errors :)
  "http://www.bestofvim.com/tip/auto-reload-your-vimrc/
  augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
  augroup END " }
  augroup myAutoCommands " {
    autocmd!
    " auto save when switching between windows
    au WinLeave ?* :wa
    " Treat .json files as .js
    au BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Open NERDTree if no file is specified
    " au vimenter * if !argc() | NERDTree | endif
    " close vim if only thing open is NERDtree
    au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
  augroup END " }
endif

" Don't use nerdtree when opening vim
let g:NERDTreeHijackNetrw=0

"session management
source ~/.vim/session.vim

"hack to add small margin on left
"set foldcolumn=1

nnoremap <Leader>m :w <BAR> !lessc % > %:t:r.css<CR><space>
