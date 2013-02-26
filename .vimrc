"A personal vim configuration vim for python code development
" NOTE: you cant use arrows, only hjkl is allowed

" NOTE: It is important that the "pathogen#infect()" function is called before
" the ":filetype on" command.

" Invoke ":helptags" on all "doc" subdirectories in the "runtimepath" variable.
"

" Setup Pathogen to manage your plugins
" " mkdir -p ~/.vim/autoload ~/.vim/bundle
" " curl -so ~/.vim/autoload/pathogen.vim
" https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim
" " Now you can install any plugin into a .vim/bundle/plugin-name/ folder
call pathogen#infect()

" automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

syntax on
filetype plugin on
filetype indent off

" tab spaces
autocmd Filetype html,htmldjango,handlebars setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript,coffee setlocal ts=2 sts=2 sw=2
autocmd Filetype css,less,sass,scss,stylus setlocal ts=2 sts=2 sw=2

set completeopt=menuone,longest,preview

"hide buffers instead of closing them this means that the current buffer can be put to background without being written; and that marks and undo history are preserved
set hidden
set undolevels=1000
" -----------------------------------------------------------------------------
" GUI / Look & Feel
" -----------------------------------------------------------------------------

" The title of the window is determined by the "titlestring" variable.
set title

let &titlestring = expand('$USERNAME') . '@' . hostname()
    \ . ' : ' . '%{fnamemodify(getcwd(), ":p:~:h")}'
    \ . ' > ' . '%{expand("%:p:~")}'

" Show status line, even if there is only one window.
set laststatus=2

" Customize status line.
set statusline+=%t
set statusline+=\ \|
set statusline+=\ %y
set statusline+=[%{&fileencoding}]
set statusline+=%{&bomb?'[BOM]':''}
set statusline+=[%{&fileformat}]
set statusline+=%r
set statusline+=%m
set statusline+=\ \|
set statusline+=\ #%n
set statusline+=\ \|
set statusline+=\ [%c/%{&textwidth}]:[%l/%L][%p%%]
set statusline+=\ \|
set statusline+=\ [%b][0x%B]
set statusline+=\ \|
set statusline+=\ [%{mode(1)}]
set statusline+=%{&paste?'[paste]':''}

" Ignore non-text or back-up files.
set wildignore=*.o,*.obj,*.a,*.lib,*.so,*.dll,*.exe,*.pyc,*.class,*.swp,*~

" Indicate matching brackets when cursor is over them.
set showmatch

" -----------------------------------------------------------------------------
" Editing
" -----------------------------------------------------------------------------
set backspace=indent,eol,start "Make "<BS>" and "<Del>" behavior less surprising. (fix backspace problem )


let g:pyflakes_use_quickfix = 0

" Python PEP8 checker F5
let g:pep8_map= '<F5>'

" -----------------------------------------------------------------------------
" Indentation
" -----------------------------------------------------------------------------
set expandtab " insert space chars whenever a tab key is pressed
set tabstop=8 " how many columns a tab counts for
set softtabstop=4 " use 4 space chars for tab with insert mode (since expandtab is enabled)
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent
"set autoindent

" -----------------------------------------------------------------------------
" Search / Regular Expressions
" -----------------------------------------------------------------------------

" Highlight search matches.
set hlsearch

" Enable spell checking.
set spell

" Use the following dictionaries for spell checking.
set spelllang=en_us

" -----------------------------------------------------------------------------
" Backup
" -----------------------------------------------------------------------------

set writebackup
set backup
set backupcopy=yes
set backupskip=
set backupdir=~/.backup
autocmd BufWritePre * let &backupext = '~@'
    \ . substitute(expand('%:p:h'), '[\\/:]', '%', 'g')
set swapfile
set updatetime=2000
set directory=~/.swap//

" -----------------------------------------------------------------------------
" Syntax Highlighting / Color Scheme
" -----------------------------------------------------------------------------
" colorscheme desert
"
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim
" http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
color wombat256mod

" -----------------------------------------------------------------------------
" Hooks
" -----------------------------------------------------------------------------

autocmd BufWritePre * :call Trim()
" autocmd FileType python autocmd BufWritePre <buffer> :call Indent()

" -----------------------------------------------------------------------------
" Mapped Key Bindings
" -----------------------------------------------------------------------------
"ai ts=4 sts=4 et sw=4 " python/django standard tab format
"
"map <F6> :set makeprg=python\ scripts/nosetests|:call MakeGreen()<CR>
map <F6> :call MakeGreen()<CR>
map <leader>a <Esc>:Ack!
map <F2> :NERDTreeToggle<CR>
map <F3> :Ack!
nmap ,g :GundoToggle<CR>
nmap ,a <Esc>:Ack!

" autocmd FileType python compiler pylint
let g:user_zen_expandabbr_key = '<c-e>'

" Write file with sudo
cmap w!! %!sudo tee > /dev/null %

" Better resize from http://www.agillo.net/simple-vim-window-management/
" nmap <left>  :3wincmd <<cr>
" nmap <right> :3wincmd ><cr>
" nmap <up>    :3wincmd +<cr>
" nmap <down>  :3wincmd -<cr>
" -----------------------------------------------------------------------------
" Custom Functions
" -----------------------------------------------------------------------------
" Re-indent the whole buffer.
" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunction

function! Indent()
  call Preserve('normal gg=G')
endfunction

" Remove trailing whitespace in the whole buffer.
function! Trim()
  call Preserve('%s/\s\+$//e')
endfunction

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

