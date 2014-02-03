## What is this?

This is my dotfiles configuration files.



## How to install configuration?

execute bootstrap.sh


## Vim Plugins

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

## Apendix

# Compile vim from source code:
* hg clone https://vim.googlecode.com/hg/ vim
* cd vim
* ./configure --enable-pythoninterp --with-features=huge --with-python-config-dir=/usr/lib/python2.7/config --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-rubyinterp --enable-luainterp --prefix=$HOME/opt/vim
* make VIMRUNTIMEDIR=/usr/share/vim/vim74
* sudo make install
* mkdir -p $HOME/bin
* cd $HOME/bin
* ln -s $HOME/opt/vim/bin/vim
check if everything was OK

* which vim
* vim --version

# Python Prerequisites:
* nose-machineout (easy_install nose-machineout)

## Contact

Leonardo Lazzaro ( lazzaroleonardo@gmail.com )
