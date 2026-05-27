#!/usr/bin/env bash
set -euo pipefail

wallpaper="${1:-}"
monitor="${2:-}"

if [ -z "$wallpaper" ]; then
  exit 0
fi

if command -v matugen >/dev/null 2>&1; then
  if [ -f "$wallpaper" ]; then
    # Generate scheme from the selected wallpaper.
    matugen image "$wallpaper" >/dev/null 2>&1 || matugen image "$wallpaper" >/dev/null 2>&1 || true
  fi
fi

# Best-effort reload (also runs after matugen template hook).
if [ -x "$HOME/.config/matugen/post-hook.sh" ]; then
  "$HOME/.config/matugen/post-hook.sh" >/dev/null 2>&1 || true
fi

# Silence unused var warning (kept for potential per-monitor logic)
: "$monitor"
