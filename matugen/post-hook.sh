#!/usr/bin/env bash
set -euo pipefail

# Hyprland (ignore if not running)
hyprctl reload >/dev/null 2>&1 || true

# fzf colors (best-effort)
if [ -f "$HOME/.config/fzf/update-colors.sh" ]; then
  bash "$HOME/.config/fzf/update-colors.sh" >/dev/null 2>&1 || true
fi

# Eww (reload generated SCSS)
if command -v eww >/dev/null 2>&1 && eww ping >/dev/null 2>&1; then
  eww reload >/dev/null 2>&1 || true
fi

# SwayNC (reload generated CSS)
if command -v swaync-client >/dev/null 2>&1; then
  swaync-client --reload-css >/dev/null 2>&1 || true
fi

# Waybar (SIGUSR2 reload)
if command -v pidof >/dev/null 2>&1; then
  if pid=$(pidof -s waybar 2>/dev/null); then
    kill -SIGUSR2 "$pid" 2>/dev/null || true
  fi
fi
