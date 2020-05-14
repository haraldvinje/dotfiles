au InsertEnter * silent execute "!echo -en \<esc>[5 q"
au InsertLeave * silent execute "!echo -en \<esc>[2 q"


set nu rnu

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,Insertenter * set norelativenumber
augroup END

syntax enable
set expandtab
set softtabstop=4
set shiftwidth=4
filetype plugin indent on
  
set statusline+=%F
set laststatus=1
let $PAGER=''
