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

# Load package manager abstraction
source "$DOTFILES_ROOT/bin/package-managers.sh"

install_os_deps_development() {
   user ' - Do you want to install development dependencies? (yes/no)'
   read -e install_dev
   if [ "$install_dev" == "yes" ]; then
       install_dev_deps
   fi
}

install_os_deps() {
   detect_package_manager
   install_basic_deps
}

install_uv() {
    if ! command -v uv >/dev/null 2>&1; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        echo "uv installed successfully"
    else
        echo "uv is already installed"
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
   install_uv
   install_os_deps_development
   if [ ! -d ~/.rbenv ]; then
       git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
   fi

   if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
       git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
   fi
   # Python setup now handled by uv
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
    `cp -r nvim ~/.config/nvim `
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
