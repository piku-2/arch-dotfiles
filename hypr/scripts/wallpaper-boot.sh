#!/usr/bin/env bash
set -euo pipefail

cache_dir="$HOME/.cache/awww"
current_file="$cache_dir/current_wallpaper"
wallpapers_dir="$HOME/Pictures/Wallpapers"

mkdir -p "$cache_dir"

fixed_wallpaper="$wallpapers_dir/operation.jpg"
fixed_wallpaper_alt="$wallpapers_dir/operationd.jpg"

# Ensure operation.jpg exists (user requested this exact name).
# If only operationd.jpg exists, create a symlink as a best-effort convenience.
if [ ! -e "$fixed_wallpaper" ] && [ -f "$fixed_wallpaper_alt" ]; then
  ln -s "$fixed_wallpaper_alt" "$fixed_wallpaper" 2>/dev/null || true
fi

resolve_fallback_wallpaper() {
  # 1) Prefer the last applied wallpaper (written by wallpaper-apply.sh)
  if [ -f "$current_file" ]; then
    local p
    p="$(head -n 1 "$current_file" || true)"
    if [ -n "${p:-}" ] && [ -f "$p" ]; then
      printf '%s' "$p"
      return 0
    fi
  fi

  # 2) If awww already has an image, reuse it
  if command -v awww >/dev/null 2>&1; then
    local q
    q="$(awww query 2>/dev/null | awk -F'image: ' '/image:/ { print $2; exit }' || true)"
    if [ -n "${q:-}" ] && [ -f "$q" ]; then
      printf '%s' "$q"
      return 0
    fi
  fi

  # 3) Fallback: first file in Wallpapers dir
  if [ -d "$wallpapers_dir" ]; then
    local f
    f="$(find "$wallpapers_dir" -maxdepth 1 -type f | sort | head -n 1 || true)"
    if [ -n "${f:-}" ] && [ -f "$f" ]; then
      printf '%s' "$f"
      return 0
    fi
  fi

  return 1
}

# Always prefer the fixed boot wallpaper.
wallpaper=""
if [ -f "$fixed_wallpaper" ]; then
  wallpaper="$fixed_wallpaper"
elif [ -f "$fixed_wallpaper_alt" ]; then
  wallpaper="$fixed_wallpaper_alt"
else
  wallpaper="$(resolve_fallback_wallpaper || true)"
fi

if [ -z "${wallpaper:-}" ]; then
  exit 0
fi

# Wait briefly for awww-daemon (started via exec-once) to become available.
if command -v awww >/dev/null 2>&1; then
  for _ in $(seq 1 50); do
    if awww query >/dev/null 2>&1; then
      break
    fi
    sleep 0.1
  done
fi

"$HOME/.config/hypr/scripts/wallpaper-apply.sh" "$wallpaper" || true
