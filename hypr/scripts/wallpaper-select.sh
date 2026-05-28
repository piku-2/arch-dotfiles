#!/usr/bin/env bash
set -euo pipefail

wallpapers_dir="$HOME/Pictures/Wallpapers"

if pidof rofi >/dev/null; then
  pkill rofi
fi

selected_wallpaper="$(
  find "$wallpapers_dir" -maxdepth 1 -type f | sort | while read -r wallpaper; do
    printf '%s\0icon\x1f%s\n' "$(basename "$wallpaper")" "$wallpaper"
  done | rofi -dmenu -p "wallpaper"
)"

if [ -z "$selected_wallpaper" ]; then
  exit 0
fi

image_fullname_path="$(find "$wallpapers_dir" -maxdepth 1 -type f -name "$selected_wallpaper" -print -quit)"

if [ -z "$image_fullname_path" ]; then
  printf 'wallpaper-select: selected wallpaper not found: %s\n' "$selected_wallpaper" >&2
  exit 1
fi

"$HOME/.config/hypr/scripts/wallpaper-apply.sh" "$image_fullname_path"
