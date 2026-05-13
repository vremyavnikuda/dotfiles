#!/usr/bin/env bash

notify-send "Adobe Photoshop CC" "Photoshop launched. Please wait." -i "$HOME/.config/waybar/icons/adobe-photoshop.svg"

SCR_PATH="$HOME/.photoshopCCV19"
CACHE_PATH="$HOME/.cache/photoshopCCV19"
RESOURCES_PATH="$SCR_PATH/resources"
WINE_PREFIX="$SCR_PATH/prefix"
 
export WINEPREFIX="$WINE_PREFIX"

wine64 "$SCR_PATH/prefix/drive_c/users/$USER/PhotoshopSE/Photoshop.exe"
