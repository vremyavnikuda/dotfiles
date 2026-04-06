#!/usr/bin/env bash
set -euo pipefail

devices=$(hyprctl devices 2>/dev/null) || exit 1

info=$(
  awk '
    BEGIN {
      in_kbd = 0
      cur_index = ""
      cur_keymap = ""
      first_index = ""
      first_keymap = ""
      best_index = ""
      best_keymap = ""
    }
    /^[[:space:]]*Keyboards:/ { in_kbd = 1; next }
    in_kbd && /^[[:space:]]*(Mice|Tablets|Touch|Switches):/ { in_kbd = 0 }
    in_kbd && /^[[:space:]]*Keyboard at/ { cur_index = ""; cur_keymap = ""; next }
    in_kbd && /^[[:space:]]*active layout index:/ {
      cur_index = $4
      if (first_index == "") first_index = cur_index
      next
    }
    in_kbd && /^[[:space:]]*active keymap:/ {
      cur_keymap = $0
      sub(/^[[:space:]]*active keymap:[[:space:]]*/, "", cur_keymap)
      if (first_keymap == "") first_keymap = cur_keymap
      next
    }
    in_kbd && /^[[:space:]]*main:[[:space:]]*/ {
      if ($2 == "yes" || $2 == "true" || $2 == "1") {
        best_index = cur_index
        best_keymap = cur_keymap
      }
      next
    }
    END {
      if (best_index != "") {
        print best_index "\t" best_keymap
      } else if (first_index != "") {
        print first_index "\t" first_keymap
      }
    }
  ' <<<"$devices"
)

index="${info%%$'\t'*}"
keymap="${info#*$'\t'}"

[ -n "$index" ] || exit 1

case "$index" in
  0) text="EN"; class="us" ;;
  1) text="RU"; class="ru" ;;
  *) text="L${index}"; class="layout" ;;
esac

tooltip=${keymap//\"/\\\"}
printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$class"
