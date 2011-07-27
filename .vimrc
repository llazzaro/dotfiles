call pathogen#infect()
syntax on
filetype plugin indent on

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

let g:pyflakes_use_quickfix = 0

let g:pep8_map='<leader>8'

set expandtab
set textwidth=79
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
"ai ts=4 sts=4 et sw=4 " python/django standard tab format
