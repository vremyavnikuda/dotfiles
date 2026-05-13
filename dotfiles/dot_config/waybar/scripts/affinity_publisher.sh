#!/usr/bin/bash

notify-send "Affinity Publisher 2" "Publisher launched. Please wait." -i "$HOME/.config/waybar/icons/affinity-publisher.svg"

WINE_PREFIX="$HOME/.AffinityLinux"
WINE="$HOME/.AffinityLinux/ElementalWarriorWine/bin/wine"

export WINEPREFIX="$WINE_PREFIX" 

$WINE "$HOME/.AffinityLinux/drive_c/Program Files/Affinity/Publisher 2/Publisher.exe"
