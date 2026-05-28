#!/usr/bin/env bash
set -euo pipefail

wallpaper="${1:-}"

if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
  printf 'wallpaper-apply: invalid wallpaper: %s\n' "$wallpaper" >&2
  exit 1
fi

awww img "$wallpaper" --transition-type any --transition-duration 2

# Persist for next boot (used by wallpaper-boot.sh)
mkdir -p "$HOME/.cache/awww"
printf '%s\n' "$wallpaper" >"$HOME/.cache/awww/current_wallpaper"

"$HOME/.config/hypr/scripts/wallpaper-effects.sh" "$wallpaper"
