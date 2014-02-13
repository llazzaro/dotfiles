#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing dotfiles for the first time"
    git clone https://github.com/llazzaro/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" == "ask" ] && export ASK="true"
    bin/bootstrap
else
    echo "Dotfiles is already installed"
fi
