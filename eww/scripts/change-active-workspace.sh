#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"

case "$direction" in
  up|left)
    hyprctl dispatch workspace e-1
    ;;
  down|right)
    hyprctl dispatch workspace e+1
    ;;
  *)
    exit 0
    ;;
esac
