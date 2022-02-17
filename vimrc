set nu rnu

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,Insertenter * set norelativenumber
augroup END

syntax enable
"set background=dark
set expandtab
set softtabstop=4
set shiftwidth=4
filetype plugin indent on
  
set statusline+=%F
set laststatus=1
let $PAGER=''

nnoremap <C-H> <C-W><C-h>
nnoremap <C-J> <C-W><C-j>
nnoremap <C-K> <C-W><C-k>
nnoremap <C-L> <C-W><C-l>
