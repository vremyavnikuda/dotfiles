#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=0
BASE_ONLY=0
WITH_AGS=0
WITH_RAZER=0
SKIP_NVIDIA=0
NVIDIA_FLAVOR="open"

log() {
  printf '[hypr-install] %s\n' "$*"
}

warn() {
  printf '[hypr-install] warning: %s\n' "$*" >&2
}

die() {
  printf '[hypr-install] error: %s\n' "$*" >&2
  exit 1
}

run() {
  printf '+ %s\n' "$*"
  if (( DRY_RUN == 0 )); then
    "$@"
  fi
}

usage() {
  cat <<'EOF'
Usage: ./install-hyprland-stack.sh [options]

Options:
  --dry-run              Show what would be installed without running commands
  --base-only            Install only the Hyprland stack, without personal apps
  --with-ags             Install AGS runtime from AUR
  --with-razer           Install Polychromatic from AUR
  --skip-nvidia          Skip NVIDIA driver packages
  --nvidia-open          Use nvidia-open-dkms (default for GTX 1660 SUPER / Turing)
  --nvidia-proprietary   Use nvidia-dkms instead of nvidia-open-dkms
  --help                 Show this help
EOF
}

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --base-only)
      BASE_ONLY=1
      ;;
    --with-ags)
      WITH_AGS=1
      ;;
    --with-razer)
      WITH_RAZER=1
      ;;
    --skip-nvidia)
      SKIP_NVIDIA=1
      ;;
    --nvidia-open)
      NVIDIA_FLAVOR="open"
      ;;
    --nvidia-proprietary)
      NVIDIA_FLAVOR="proprietary"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
  shift
done

command -v pacman >/dev/null 2>&1 || die "this script is intended for Arch Linux or Arch-based distributions"

find_aur_helper() {
  if command -v paru >/dev/null 2>&1; then
    printf 'paru\n'
    return
  fi

  if command -v yay >/dev/null 2>&1; then
    printf 'yay\n'
    return
  fi

  printf '\n'
}

detect_kernel_headers() {
  case "$(uname -r)" in
    *-zen*)
      printf 'linux-zen-headers\n'
      ;;
    *-lts*)
      printf 'linux-lts-headers\n'
      ;;
    *-hardened*)
      printf 'linux-hardened-headers\n'
      ;;
    *)
      printf 'linux-headers\n'
      ;;
  esac
}

PACMAN_PACKAGES=(
  base-devel
  git
  dbus
  dconf
  gsettings-desktop-schemas
  cinnamon-desktop
  hyprland
  hyprpaper
  hypridle
  hyprlock
  hyprpicker
  hyprpolkitagent
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  waybar
  swaync
  easyeffects
  pipewire
  pipewire-pulse
  wireplumber
  pavucontrol
  ghostty
  nautilus
  blueman
  bluez
  bluez-utils
  cliphist
  brightnessctl
  jq
  bc
  sshpass
  grim
  slurp
  satty
  wl-clipboard
  playerctl
  btop
  lm_sensors
  dart-sass
  ttf-jetbrains-mono-nerd
  adw-gtk-theme
  qt6ct
  bibata-cursor-theme
)

AUR_PACKAGES=(
  vicinae-bin
  xwaylandvideobridge-bin
  wlogout-git
  grimblast-git
  tilix
)

OPTIONAL_APP_PACKAGES=(
  telegram-desktop
)

OPTIONAL_TOOLING_PACKAGES=(
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
  github-cli
  lazygit
  curl
  wget
  unzip
  zip
  gedit
  alacritty
  code
  pamixer
  obsidian
  neovim
  tree
  ripgrep
  fd
  imv
  swayimg
  python
  python-pip
  nodejs
  npm
)

OPTIONAL_AUR_APP_PACKAGES=(
  zen-browser-bin
  throne-bin
)

OPTIONAL_AUR_TOOLING_PACKAGES=(
  yandex-browser
  thorium-browser
  tofi
  wezterm-git
  jome
)

AGS_AUR_PACKAGES=(
  aylurs-gtk-shell-git
)

RAZER_AUR_PACKAGES=(
  polychromatic
)

NVIDIA_PACKAGES=(
  egl-wayland
  libva-nvidia-driver
  nvidia-utils
  lib32-nvidia-utils
)

if (( SKIP_NVIDIA == 0 )); then
  NVIDIA_PACKAGES+=("$(detect_kernel_headers)")

  if [[ "$NVIDIA_FLAVOR" == "open" ]]; then
    NVIDIA_PACKAGES+=(nvidia-open-dkms)
  else
    NVIDIA_PACKAGES+=(nvidia-dkms)
  fi
fi

install_pacman_packages() {
  local packages=("$@")
  ((${#packages[@]})) || return 0
  run sudo pacman -Syu --needed "${packages[@]}"
}

install_aur_packages() {
  local packages=("$@")
  local helper

  ((${#packages[@]})) || return 0
  helper="$(find_aur_helper)"

  if [[ -z "$helper" ]]; then
    warn "AUR helper not found. Install paru or yay first, then install these packages manually:"
    printf '  %s\n' "${packages[@]}"
    return 0
  fi

  run "$helper" -S --needed "${packages[@]}"
}

print_manual_notes() {
  cat <<'EOF'

Manual follow-up:
  1. `/home/vremyavnikuda/.opencode/bin/opencode` is a private path and is not installed by this script.
EOF
}

log "Installing core Hyprland stack"
install_pacman_packages "${PACMAN_PACKAGES[@]}"

if (( SKIP_NVIDIA == 0 )); then
  log "Installing NVIDIA stack for GTX 1660 SUPER (${NVIDIA_FLAVOR})"
  install_pacman_packages "${NVIDIA_PACKAGES[@]}"
else
  log "Skipping NVIDIA driver packages"
fi

log "Installing AUR packages used directly by the Hyprland stack"
install_aur_packages "${AUR_PACKAGES[@]}"

if (( BASE_ONLY == 0 )); then
  log "Installing app and tooling packages"
  install_pacman_packages "${OPTIONAL_APP_PACKAGES[@]}"
  install_pacman_packages "${OPTIONAL_TOOLING_PACKAGES[@]}"
  install_aur_packages "${OPTIONAL_AUR_APP_PACKAGES[@]}"
  install_aur_packages "${OPTIONAL_AUR_TOOLING_PACKAGES[@]}"
else
  log "Skipping personal app and tooling packages because --base-only was requested"
fi

if (( WITH_AGS == 1 )); then
  log "Installing AGS runtime"
  install_aur_packages "${AGS_AUR_PACKAGES[@]}"
else
  log "Skipping AGS runtime; pass --with-ags if you want the current autostart to find it"
fi

if (( WITH_RAZER == 1 )); then
  log "Installing Polychromatic"
  install_aur_packages "${RAZER_AUR_PACKAGES[@]}"
else
  log "Skipping Polychromatic; pass --with-razer only if you really use Razer devices"
fi

print_manual_notes

log "Done"
