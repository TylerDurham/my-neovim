#/usr/bin/env bash

stow -S . -t ~/

if [[ -f ~/.config/nvim ]]; then
  mv ~/.config/nvim ~/.config/nvim.bak
fi

ln -s -f ~/.config/my-neovim ~/.config/nvim
