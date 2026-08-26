#!/bin/sh

DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Installing dotfiles for the first time"
  git clone https://github.com/llazzaro/dotfiles.git "$DOTFILES_DIR"
else
  echo "Updating dotfiles..."
  git -C "$DOTFILES_DIR" pull
fi

cd "$DOTFILES_DIR" || exit 1
bash bin/bootstrap.sh
