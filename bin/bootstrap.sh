#!/usr/bin/env bash
#
# bootstrap installs things.
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

DOTFILES_ROOT="`pwd`"

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

function detect_package_manager
{
case `uname` in
  Linux )
     LINUX=1
     type dnf >/dev/null 2>&1 && { package_manager='dnf'; }
     type apt-get >/dev/null 2>&1 && { package_manager='apt-get'; }
     type zypper >/dev/null 2>&1 && { package_manager='zypper'; }
     ;;
  Darwin )
     DARWIN=1
     type brew >/dev/null 2>&1 && { package_manager='brew'; }
     ;;
  * )
     # Handle AmigaOS, CPM, and modified cable modems here.
     ;;
esac
echo "Package manager detected is $package_manager"
}

install_os_deps_development() {
   user ' - Do you want to install development dependencies? (yes/no)'
   read -e install_dev
   if [ "install_dev" != "yes" ]
   then
       if [ "$package_manager" == "dnf" ]
       then
           sudo dnf update
           sudo dnf install npm
           sudo dnf install make automake gcc gcc-c++ gpg
           sudo dnf install dkms binutils make patch libgomp glibc-headers
           sudo dnf install libxslt-devel libxml2-devell nmap libffi-devel
           sudo dnf install gitflow subversion ghc ack hg
       fi
       if [ "$package_manager" == "apt-get" ]
       then
           sudo apt-get update
           sudo apt-get -y install python-flake8 python3-flake8
           sudo apt-get -y install python-setuptools python-dev libxml2-dev libxslt1-dev fontconfig vim
           sudo apt-get -y install make git-core build-essential libffi-dev
           sudo apt-get -y install openssl libssl-dev autoconf automake libtool ack-grep mercurial docker
           sudo apt-get install -y libjpeg8 libfreetype6 libfreetype6-dev libreadline-dev
       fi

       if [ "$package_manager" == "brew" ]
       then
          # You must install vim after python so that it'll compile with homebrew's python.
          brew update
          brew install node doctl kubectx fluxctl helm postgres openssl automake libtool kube-ps1 stern
          brew install openssl readline sqlite3 xz zlib doctl
          brew install derailed/popeye/popeye rbenv
          echo "Downloading kubectl"
          curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
          chmod +x ./kubectl
          sudo mv ./kubectl /usr/local/bin/kubectl
          sudo chown root: /usr/local/bin/kubectl

       fi
    fi
}

install_os_deps() {
   detect_package_manager

   if [ "$package_manager" == "dnf" ]
   then
       sudo dnf update
       sudo dnf install git mc htop npm wget zsh ach xclip
   fi
   if [ "$package_manager" == "apt-get" ]
   then
       sudo apt-get update
       sudo apt-get -y install zsh git nmap curl tmux iotop htop openssl xclip
   fi

   if [ "$package_manager" == "brew" ]
   then
      brew install tmux wget python
      brew install reattach-to-user-namespace
      # You must install vim after python so that it'll compile with homebrew's python.
      brew install vim zsh
   fi
}

install_pyenv() {
    if [ -d ~/.pyenv ]; then
        pyenv update
    else
        curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
        echo -e 'if [ -z "$BASH_VERSION" ]; then'\
          '\n  export PYENV_ROOT="$HOME/.pyenv"'\
          '\n  export PATH="$PYENV_ROOT/bin:$PATH"'\
          '\n  eval "$(pyenv init --path)"'\
          '\nfi' >>~/.profile
        echo -e 'if [ -z "$BASH_VERSION" ]; then'\
          '\n  export PYENV_ROOT="$HOME/.pyenv"'\
          '\n  export PATH="$PYENV_ROOT/bin:$PATH"'\
          '\n  eval "$(pyenv init --path)"'\
          '\nfi' >>~/.zprofile
          zsh
    fi

}

install_python_deps() {
   pip install flake8 vex --user
   pip install termtosvg --user
   pip install --user powerline-status
}

install_powerlinefonts() {
   if [ -d ~/.powerline ]; then
       cd ~/.powerline
       git pull
       cd -
       cd ~/.fonts
       git pull
       cd -
   else
       mkdir -p ~/.powerline
       mkdir -p ~/.fonts
       mkdir -p ~/.config/fontconfig
       mkdir -p ~/.config/fontconfig/conf.d
       git clone https://github.com/Lokaltog/powerline.git ~/.powerline
       if [ ! "$package_manager" == "brew" ]; then
            git clone https://github.com/Lokaltog/powerline-fonts.git ~/.fonts
            sudo cp ~/.powerline/font/10-powerline-symbols.conf /etc/fonts/conf.d
            fc-cache -vf ~/.fonts
            cp ~/.powerline/font/PowerlineSymbols.otf ~/.fonts
       fi
   fi
}

install_tmux_plugins() {
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

install_deps() {
   install_os_deps
   install_pyenv
   install_os_deps_development
   if [ ! -d ~/.rbenv ]; then
       git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
   fi

   if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
       git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
   fi
   pyenv install 3.9.4
   pyenv local 3.9.4
   pip install --user powerline-status
   # pip install git+https://github.com/Lokaltog/powerline.git --user
   if [ ! -d ~/.oh-my-zsh ]; then
       curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
   fi
   install_powerlinefonts
   install_tmux_plugins
}

setup_gitconfig () {
  if ! [ -f git/gitconfig.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.symlink.example > git/gitconfig.symlink

    success 'gitconfig'
  fi
}

link_files () {
  ln -s $1 $2
  success "linked $1 to $2"
}

install_dotfiles () {
  info 'installing dotfiles'

  overwrite_all=false
  backup_all=false
  skip_all=false

  for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink`
  do
    dest="$HOME/.`basename \"${source%.*}\"`"

    if [ -f $dest ] || [ -d $dest ]
    then

      overwrite=false
      backup=false
      skip=false

      if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
      then
        user "File already exists: `basename $source`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi

      if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
      then
        rm -rf $dest
        success "removed $dest"
      fi

      if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
      then
        mv $dest $dest\.backup
        success "moved $dest to $dest.backup"
      fi

      if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
      then
        link_files $source $dest
      else
        success "skipped $source"
      fi

    else
      link_files $source $dest
    fi
    `cp -r vim/compiler ~/.vim/ `
    `cp -r vim/colors ~/.vim/ `
    `mkdir -p ~/.xmonad `
    `cp -r xmonad/xmonad.hs ~/.xmonad/xmonad.hs `
  done
}


user ' - Do you want to install OS deps? (yes/no)'
read -e deps
if [ "$deps" == "yes" ]
then
  install_deps
  install_python_deps
fi

install_dotfiles

# If we're on a Mac, let's install and setup homebrew.
if [ "$(uname -s)" == "Darwin" ]
then
  info "installing dependencies"
  if . bin/dot > /tmp/dotfiles-dot 2>&1
  then
    success "dependencies installed"
  else
    fail "error installing dependencies"
  fi
fi

echo '  All installed!'
