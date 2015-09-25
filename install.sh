#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing dotfiles for the first time"
  git clone https://github.com/llazzaro/dotfiles.git "$HOME/.dotfiles"
else
  echo "Updating dotfiles\n"
  cd "$HOME/.dotfiles" && git pull
fi

cd "$HOME/.dotfiles"
bin/bootstrap
