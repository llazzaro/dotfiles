![Vim logo](http://1.bp.blogspot.com/-fskvnqzDiYo/TjBEBr2l0ZI/AAAAAAAAAiY/KbUQz8wNkRw/s1600/vim-editor_logo.png)<br/>

## What is this?

This is my vim configuration for use with python and php.
# Compile vim from source code:

* sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev mercurial
* sudo apt-get remove vim vim-runtime gvim vim-tiny vim-common vim-gui-common
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

## How to install configuration?

Backup your vim settings (.vim directory and .vimrc).
Now clone my settings and move them to your home (is recommended to delete your
settings)

* git clone git@github.com:llazzaro/.vim.git
* cd
* ln -s .vim/.vimrc .vimrc


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


## How to remove plugin



## Contact

Leonardo Lazzaro ( lazzaroleonardo@gmail.com )
