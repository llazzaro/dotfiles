![Vim logo](http://1.bp.blogspot.com/-fskvnqzDiYo/TjBEBr2l0ZI/AAAAAAAAAiY/KbUQz8wNkRw/s1600/vim-editor_logo.png)<br/>

## What is this?

This is my vim configuration for use with python and php.

## How to install?

Backup your vim settings (.vim directory and .vimrc). 
Now clone my settings and move them to your home (is recommended to delete your
settings)

git clone git@github.com:llazzaro/.vim.git
cd .vim
git submodule update --init


## Plugins

ack  
command-t  
fugitive  
git  
gundo  
makegreen  
minibufexpl  
nerdtree  
pep8  
pydoc  
pyflakes  
pysmell  
py.test  
ropevim  
snipmate  
sparkup  
supertab  
surround  
svncommand 


## How to add more plugins

To manage plugins easy I use pathogen (check http://www.vim.org/scripts/script.php?script_id=2332)

Example to install PEP8 plugin
In .vim directory :

git submodule add https://github.com/sontek/rope-vim.git bundle/ropevim
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update

## How to remove plugin
Please email me if you find a better way to remove a git submodule

- Delete the relevant line from the .gitmodules file.
- Delete the relevant section from .git/config.
- Run git rm --cached path_to_submodule (no trailing slash).
- Commit and delete the now untracked submodule files.


## TODO

- Python django autocomplete

## Contact

Leonardo Lazzaro ( lazzaroleonardo@gmail.com )
