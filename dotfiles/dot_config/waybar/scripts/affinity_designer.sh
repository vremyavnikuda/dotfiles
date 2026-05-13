#!/usr/bin/bash

notify-send "Affinity Designer 2" "Designer launched. Please wait." -i "$HOME/.config/waybar/icons/affinity-designer.svg"

WINE_PREFIX="$HOME/.AffinityLinux"
WINE="$HOME/.AffinityLinux/ElementalWarriorWine/bin/wine"

export WINEPREFIX="$WINE_PREFIX" 

$WINE "$HOME/.AffinityLinux/drive_c/Program Files/Affinity/Designer 2/Designer.exe"
