#!/usr/bin/env bash
set -euo pipefail

current_wallpaper_path="${1:-}"
destination_wallpaper_dir="$HOME/.cache/awww"

if [ -z "$current_wallpaper_path" ]; then
  current_wallpaper_path="$(awww query | awk -F'image: ' '/image:/ { print $2; exit }')"
fi

if [ -z "$current_wallpaper_path" ] || [ ! -f "$current_wallpaper_path" ]; then
  printf 'wallpaper-effects: invalid wallpaper: %s\n' "$current_wallpaper_path" >&2
  exit 1
fi

mkdir -p "$destination_wallpaper_dir"
rm -f "$destination_wallpaper_dir/normal.png"
vipsthumbnail "$current_wallpaper_path" -o "$destination_wallpaper_dir/normal.png"
