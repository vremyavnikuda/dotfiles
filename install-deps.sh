#!/usr/bin/env bash
set -euo pipefail

# Simple batch installer for Arch Linux packages.
# Run it once and it installs everything below.

PACMAN_PACKAGES=(
  base-devel
  gcc
  clang
  clang-tools-extra
  llvm
  lld
  cmake
  ninja
  gdb
  lldb
  pkgconf
  ccache
  valgrind
  git
  github-cli
  lazygit
  curl
  wget
  unzip
  zip
  gedit
  telegram-desktop
  alacritty
  polkit-kde-agent
  dunst
  waybar
  swww
  wl-clipboard
  cliphist
  hypridle
  hyprlock
  dbus
  nautilus
  code
  hyprpicker
  wlogout
  pamixer
  playerctl
  brightnessctl
  obsidian
  neovim
  btop
  tree
  ripgrep
  fd
  jq
  imv
  swayimg
  python
  python-pip
  nodejs
  npm
)

# Optional AUR packages (requires yay).
AUR_PACKAGES=(
  visual-studio-code-bin
  yandex-browser
  thorium-browser
  tofi
  wezterm-git
  jome
)

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

need_cmd() {
  if ! have_cmd "$1"; then
    echo "Error: required command not found: $1" >&2
    exit 1
  fi
}

run_sudo() {
  sudo "$@"
}

ensure_yay() {
  if have_cmd yay; then
    return 0
  fi

  echo "==> yay not found. Installing yay from AUR..."
  need_cmd git
  need_cmd makepkg

  local tmp_dir
  tmp_dir="$(mktemp -d /tmp/yay-install-XXXXXX)"

  (
    set -euo pipefail
    cd "$tmp_dir"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
  )

  rm -rf "$tmp_dir"
}

main() {
  if [[ $# -gt 0 ]]; then
    echo "Warning: this script ignores arguments and installs everything." >&2
  fi

  need_cmd pacman

  echo "==> Checking sudo access..."
  sudo -v

  echo "==> Upgrading system (pacman -Syu)..."
  run_sudo pacman -Syu --noconfirm

  echo "==> Ensuring base build tools (base-devel, git)..."
  run_sudo pacman -S --needed --noconfirm base-devel git

  if [[ "${#PACMAN_PACKAGES[@]}" -gt 0 ]]; then
    echo "==> Installing pacman packages..."
    run_sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
  else
    echo "==> No pacman packages configured."
  fi

  if [[ "${#AUR_PACKAGES[@]}" -eq 0 ]]; then
    echo "==> Skipping AUR packages."
    return 0
  fi

  ensure_yay

  echo "==> Installing AUR packages with yay..."
  yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
}

main "$@"
