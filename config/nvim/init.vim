"Harald's nvim configuration
"Plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-surround'
"Plugin for moving, deleting files in vim and on disk 
Plug 'tpope/vim-eunuch'
"
Plug 'vimwiki/vimwiki'
Plug 'junegunn/goyo.vim'
Plug 'mattn/emmet-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim'
Plug 'simeji/winresizer'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'lervag/vimtex'
Plug 'udalov/kotlin-vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
call plug#end()

"basics
filetype plugin indent on
syntax on 

"Yanking
nnoremap Y y$

"Pasting
nnoremap p gp
nnoremap P gP

"numbering
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set cursorline
set nocompatible

"split navigations
nnoremap <C-H> <C-W><C-h>
nnoremap <C-J> <C-W><C-j>
nnoremap <C-K> <C-W><C-k>
nnoremap <C-L> <C-W><C-l>

nnoremap <C-Left>   <C-W><C-h>
nnoremap <C-Down>   <C-W><C-j>
nnoremap <C-Up>     <C-W><C-k>
nnoremap <C-Right>  <C-W><C-l>

set splitbelow
set splitright

"resize windows
let g:winresizer_start_key = '<C-S>'

let g:python3_host_prog = '/bin/python3'

"Aesthetics
colorscheme PaperColor
hi Normal guibg=NONE ctermbg=NONE

"StatusLine
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

"NerdTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore=['.git']
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

"NerdTree Syntax Highligt
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeSyntaxEnabledExtensions = ['jsx', 'tsx']

"LeaderButtons
let mapleader = "\<Space>"
let maplocalleader = "\\"

"indeting
vnoremap < <gv
vnoremap > >gv

"spacing and tabs
set incsearch
set ignorecase
set smartcase
set nohlsearch
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" change spacing for language specific
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype javascript,typescript,javascript.jsx,typescript.tsx,css setlocal ts=2 sts=2 sw=2
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

"coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <silent> gd <Plug>(coc-definition)
"nmap <leader> ac <Plug>(coc-codeaction)
nmap <leader> ac <Plug>(coc-implementation)

"fzf
let g:ctrlp_map = '<c-t>'
nnoremap <c-b> :CtrlPBuffer<Cr>
nnoremap <c-p> :Files<Cr>

"vimtex
let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : 'build',
            \}
let g:vimtex_view_method = 'mupdf'
