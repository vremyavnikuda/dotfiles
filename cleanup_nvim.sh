#!/bin/bash

#удаление конфигурационных файлов nvim

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cashe/nvim
rm -rf ~/.local/state/nvim

#delete duplicate
rm -rf ~/.local/share/nvim

find ~ .name "*nvim*"

echo "Neovim configurations and cache removed successfully. Search completed."
