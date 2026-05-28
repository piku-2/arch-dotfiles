#!/usr/bin/env bash
set -euo pipefail

wallpapers_dir="$HOME/Pictures/Wallpapers"

random_wallpaper="$(find "$wallpapers_dir" -maxdepth 1 -type f | shuf -n 1)"

if [ -z "$random_wallpaper" ]; then
  printf 'wallpaper-random: no wallpapers found in %s\n' "$wallpapers_dir" >&2
  exit 1
fi

"$HOME/.config/hypr/scripts/wallpaper-apply.sh" "$random_wallpaper"
