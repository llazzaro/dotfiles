"pathogen
call pathogen#infect()

" automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

syntax on
filetype plugin off
filetype indent off

" tab spaces
autocmd Filetype html,htmldjango,handlebars setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript,coffee setlocal ts=2 sts=2 sw=2
autocmd Filetype css,less,sass,scss,stylus setlocal ts=2 sts=2 sw=2

set completeopt=menuone,longest,preview

let g:pyflakes_use_quickfix = 0

let g:pep8_map= '<F5>'

" general
set expandtab " insert space chars whenever a tab key is pressed
set tabstop=8 " how many columns a tab counts for
set softtabstop=4 " use 4 space chars for tab with insert mode (since expandtab is enabled)
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent
set backspace=indent,eol,start " fix backspace problem
"set autoindent


colorscheme desert
"ai ts=4 sts=4 et sw=4 " python/django standard tab format
"
"map <F6> :set makeprg=python\ scripts/nosetests|:call MakeGreen()<CR>
map <F6> :call MakeGreen()<CR>
map <leader>a <Esc>:Ack!
map <F2> :NERDTreeToggle<CR>
map <F3> :Ack!

" autocmd FileType python compiler pylint
let g:user_zen_expandabbr_key = '<c-e>'
" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
     project_base_dir = os.environ['VIRTUAL_ENV']
     sys.path.insert(0, project_base_dir)
     activate_this = os.path.join(project_base_dir,'bin/activate_this.py')
     execfile(activate_this, dict(__file__=activate_this))
EOF

