#!/usr/bin/env bash
set -euo pipefail

devices=$(hyprctl devices 2>/dev/null) || exit 1

kbd=$(
  awk '
    BEGIN { in_kbd = 0; name = ""; first = ""; found = 0 }
    /^[[:space:]]*Keyboards:/ { in_kbd = 1; next }
    in_kbd && /^[[:space:]]*(Mice|Tablets|Touch|Switches):/ { in_kbd = 0 }
    in_kbd && /^[[:space:]]*Keyboard at/ {
      if (getline nextline) {
        name = nextline
        sub(/^[[:space:]]+/, "", name)
        if (first == "") first = name
      }
      next
    }
    in_kbd && /^[[:space:]]*main:[[:space:]]*/ {
      if ($2 == "yes" || $2 == "true" || $2 == "1") {
        print name
        found = 1
        exit
      }
    }
    END {
      if (!found && first != "") print first
    }
  ' <<<"$devices"
)

[ -n "$kbd" ] || exit 1
hyprctl switchxkblayout "$kbd" next
