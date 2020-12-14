filetype plugin indent on
syntax on
colorscheme default
set ttimeoutlen=0
set clipboard=unnamedplus
set mouse=a
set number relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noswapfile
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> "+p
nmap <C-v> "+p
imap <C-v> <C-r><C-o>+
autocmd BufWritePre * %s/\s\+$//e
nnoremap <F3> :set invnumber invrelativenumber<CR>
inoremap <F3> <C-O>:set invnumber invrelativenumber<CR>
set hlsearch
set ignorecase
set incsearch
