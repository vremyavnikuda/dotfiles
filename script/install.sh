#!/bin/bash

# Обновление системы
sudo pacman -Syu

# Установка официальных пакетов через pacman
sudo pacman -S \
    noisetorch \
    qtcreator \
    gcc \
    mpd \
    ncmpcpp \
    unzip \
    file-roller \
    make \
    base \
    ttf-hack \
    base-devel \
    blueman \
    btop \
    dbus-glib \
    dunst \
    fastfetch \
    fish \
    git \
    gnome-keyring \
    grim \
    hyprlock \
    hyprpaper \
    hyprshot \
    inetutils \
    iwd \
    kitty \
    meson \
    neovim \
    clangb \
    nwg-look \
    obsidian \
    otf-font-awesome \
    papirus-icon-theme \
    pkgfile \
    powerline-fonts \
    smartmontools \
    telegram-desktop \
    thunar \
    ttf-dejavu \
    ttf-font-awesome \
    ttf-jetbrains-mono \
    waybar \
    wireplumber \
    wofi \
    zram-generator

# Установка AUR пакетов через yay
yay -S \
    blue-recorder \
    github-desktop \
    ytdownloader

echo "Установка завершена!"
