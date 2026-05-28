#!/usr/bin/env bash
set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
hypr_signature="${HYPRLAND_INSTANCE_SIGNATURE:-}"

if [ -z "$hypr_signature" ]; then
  hypr_signature="$(find "$runtime_dir/hypr" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %f\n' 2>/dev/null | sort -nr | awk 'NR == 1 { print $2 }')"
fi

hyprctl workspaces -j | jq -c 'sort_by(.id)'

event_socket="$runtime_dir/hypr/$hypr_signature/.socket2.sock"
[ -S "$event_socket" ] || exit 0

socat -u "UNIX-CONNECT:$event_socket" - | while read -r _; do
  hyprctl workspaces -j | jq -c 'sort_by(.id)'
done
