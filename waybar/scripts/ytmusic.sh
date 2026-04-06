#!/usr/bin/env bash
set -euo pipefail

if ! command -v playerctl >/dev/null 2>&1; then
  printf '{"text":"󰎆 YT: playerctl?","class":"error","tooltip":"Install playerctl to show media info."}\n'
  exit 0
fi

players=$(playerctl -l 2>/dev/null || true)
if [ -z "$players" ]; then
  printf '{"text":"󰎆 YT: off","class":"stopped","tooltip":"No MPRIS players found."}\n'
  exit 0
fi

# Prefer dedicated YouTube Music players or browser instances.
preferred_prefixes=(
  "youtube-music"
  "youtube-music-desktop-app"
  "com.github.th_ch.youtube_music"
  "ytmdesktop"
  "chromium"
  "google-chrome"
  "brave"
  "vivaldi"
  "firefox"
  "yandex-music"
)

pick_player=""

is_preferred() {
  local p="$1"
  local pref
  for pref in "${preferred_prefixes[@]}"; do
    case "$p" in
      "$pref"*) return 0 ;;
    esac
  done
  return 1
}

# 1) Preferred + Playing
while IFS= read -r p; do
  if is_preferred "$p"; then
    status=$(playerctl -p "$p" status 2>/dev/null || true)
    if [ "$status" = "Playing" ]; then
      pick_player="$p"
      break
    fi
  fi
done <<<"$players"

# 2) Preferred + YouTube URL
if [ -z "$pick_player" ]; then
  while IFS= read -r p; do
    if is_preferred "$p"; then
      url=$(playerctl -p "$p" metadata --format '{{xesam:url}}' 2>/dev/null || true)
      if printf '%s' "$url" | grep -qiE 'music\.youtube\.com|youtube\.com'; then
        pick_player="$p"
        break
      fi
    fi
  done <<<"$players"
fi

# 3) Any preferred
if [ -z "$pick_player" ]; then
  while IFS= read -r p; do
    if is_preferred "$p"; then
      pick_player="$p"
      break
    fi
  done <<<"$players"
fi

# 4) First Playing
if [ -z "$pick_player" ]; then
  while IFS= read -r p; do
    status=$(playerctl -p "$p" status 2>/dev/null || true)
    if [ "$status" = "Playing" ]; then
      pick_player="$p"
      break
    fi
  done <<<"$players"
fi

# 5) Fallback to the first listed player.
if [ -z "$pick_player" ]; then
  pick_player=$(printf '%s\n' "$players" | head -n1)
fi

status=$(playerctl -p "$pick_player" status 2>/dev/null || true)
artist=$(playerctl -p "$pick_player" metadata --format '{{artist}}' 2>/dev/null || true)
title=$(playerctl -p "$pick_player" metadata --format '{{title}}' 2>/dev/null || true)
if [ -z "$title" ]; then
  title=$(playerctl -p "$pick_player" metadata --format '{{xesam:title}}' 2>/dev/null || true)
fi

if [ -z "$title" ]; then
  printf '{"text":"󰎆 YT: idle","class":"stopped","tooltip":"Player: %s"}\n' "$pick_player"
  exit 0
fi

track="$title"
if [ -n "$artist" ]; then
  track="$artist - $title"
fi

icon="󰎆"
class="paused"
if [ "$status" = "Playing" ]; then
  class="playing"
fi

# Escape JSON
track_esc=$(printf '%s' "$track" | sed 's/\\/\\\\/g; s/"/\\"/g')
player_esc=$(printf '%s' "$pick_player" | sed 's/\\/\\\\/g; s/"/\\"/g')
status_esc=$(printf '%s' "$status" | sed 's/\\/\\\\/g; s/"/\\"/g')

printf '{"text":"%s %s","class":"%s","tooltip":"%s\nPlayer: %s"}\n' "$icon" "$track_esc" "$class" "$status_esc" "$player_esc"
