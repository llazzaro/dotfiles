call pathogen#infect()
syntax on
filetype plugin indent on

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

let g:pyflakes_use_quickfix = 0

let g:pep8_map= '<F5>'


set expandtab
set textwidth=79
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
"ai ts=4 sts=4 et sw=4 " python/django standard tab format
"
"map <F6> :set makeprg=python\ scripts/nosetests|:call MakeGreen()<CR>
map <F6> :call MakeGreen()<CR>
map <leader>a <Esc>:Ack!
map <F2> :NERDTreeToggle<CR>
map <F3> :Ack!

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
