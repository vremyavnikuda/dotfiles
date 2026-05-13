#!/usr/bin/bash

notify-send "Affinity Photo 2" "Photo launched. Please wait." -i "$HOME/.config/waybar/icons/affinity-photo.svg"

WINE_PREFIX="$HOME/.AffinityLinux"
WINE="$HOME/.AffinityLinux/ElementalWarriorWine/bin/wine"

export WINEPREFIX="$WINE_PREFIX" 

$WINE "$HOME/.AffinityLinux/drive_c/Program Files/Affinity/Photo 2/Photo.exe"
