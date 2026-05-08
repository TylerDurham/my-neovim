#/usr/bin/env bash

stow -S . -t ~/
mv ~/.config/nvim ~/.config/nvim.bak
ln -s -f ~/.config/my-neovim ~/.config/nvim
