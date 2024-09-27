#!/bin/bash
# Обновление системы
sudo pacman -Syu
echo "arch update"
sudo pacman -S go
echo "go install"
go version
mkdir -p ~/go/{bin,pkg,src}
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
