#!/usr/bin/env bash
set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
hypr_signature="${HYPRLAND_INSTANCE_SIGNATURE:-}"

update_monitors() {
  local external_monitors external_count

  external_monitors="$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP-") | not) | .name')"
  external_count="$(grep -c . <<<"$external_monitors")"

  if [ "$external_count" -gt 0 ]; then
    hyprctl keyword monitor "eDP-1,disable"
  else
    hyprctl keyword monitor "eDP-1,preferred,auto,auto"
    sleep 1
  fi

  awww restore >/dev/null 2>&1 || true

  # Re-open eww bar on the current monitor set
  ~/.config/eww/scripts/bar.sh >/dev/null 2>&1 || true
}

handle() {
  case "$1" in
    monitoradded* | monitorremoved*)
      sleep 1
      update_monitors
      ;;
  esac
}

until awww query >/dev/null 2>&1; do
  sleep 0.5
done

update_monitors

if [ -z "$hypr_signature" ]; then
  hypr_signature="$(find "$runtime_dir/hypr" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %f\n' 2>/dev/null | sort -nr | awk 'NR == 1 { print $2 }')"
fi

if [ -z "$hypr_signature" ]; then
  exit 0
fi

socket="$runtime_dir/hypr/$hypr_signature/.socket2.sock"
[ -S "$socket" ] || exit 0

socat -U - "UNIX-CONNECT:$socket" | while read -r line; do
  handle "$line"
done
