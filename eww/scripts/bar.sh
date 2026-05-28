#!/usr/bin/env bash

set -u -o pipefail

EWW_BIN="${EWW_BIN:-/usr/bin/eww}"

open_bar_for_monitor() {
  local window_id="$1"
  shift

  # Try a few possible identifiers for the same monitor.
  # On this setup, eww's `--screen` matches Hyprland's `model` field.
  local screen
  for screen in "$@"; do
    [ -n "${screen}" ] || continue
    if "$EWW_BIN" open bar_widget --id "$window_id" --screen "$screen" 2>/dev/null; then
      return 0
    fi
  done

  # Fallback: open on default screen
  "$EWW_BIN" open bar_widget --id "$window_id"
}

# Ensure daemon is running (no-op if already running)
"$EWW_BIN" daemon 2>/dev/null || true

# Close any existing bar instances
active_ids="$($EWW_BIN active-windows | awk -F': ' '$2 == "bar_widget" {print $1}')"
if [ -n "${active_ids}" ]; then
  while IFS= read -r id; do
    [ -n "${id}" ] || continue
    "$EWW_BIN" close "${id}" 2>/dev/null || true
  done <<<"${active_ids}"
fi

# Open a bar on every Hyprland monitor
if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  hyprctl -j monitors 2>/dev/null | jq -r '.[] | [.id, (.model // ""), (.name // ""), (.description // "")] | @tsv' \
    | while IFS=$'\t' read -r mon_id model name desc; do
        screen="${model:-${name:-}}"
        safe_screen="${screen//[^A-Za-z0-9._-]/_}"
        window_id="bar_${mon_id}_${safe_screen:-default}"
        open_bar_for_monitor "$window_id" "$model" "$name" "$desc" "$mon_id"
      done
else
  # Non-Hyprland fallback
  "$EWW_BIN" open bar_widget --id bar_default
fi
