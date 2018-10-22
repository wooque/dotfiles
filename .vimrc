filetype plugin indent on
syntax on
colorscheme default
set clipboard=unnamedplus
set mouse=a
set number
set pastetoggle=<F9>
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noswapfile
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
autocmd BufWritePre *.py %s/\s\+$//e
