#!/usr/bin/env bash
set -euo pipefail

wallpaper="${1:-}"

if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
  printf 'wallpaper-apply: invalid wallpaper: %s\n' "$wallpaper" >&2
  exit 1
fi

awww img "$wallpaper" --transition-type any --transition-duration 2

"$HOME/.config/hypr/scripts/wallpaper-effects.sh" "$wallpaper"
