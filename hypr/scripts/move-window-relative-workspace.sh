#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"
case "$direction" in
  right) delta=1 ;;
  left) delta=-1 ;;
  *) exit 1 ;;
esac

current_id=$(
  hyprctl -j activeworkspace \
    | jq -r '.id // empty'
)

[[ -n "${current_id}" ]] || exit 1

target_id=$((current_id + delta))
if (( target_id < 1 )); then
  target_id=1
fi

hyprctl dispatch movetoworkspace "${target_id}"
