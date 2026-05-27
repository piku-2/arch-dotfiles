#!/usr/bin/env bash
set -euo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
hypr_signature="${HYPRLAND_INSTANCE_SIGNATURE:-}"

if [ -z "$hypr_signature" ]; then
  hypr_signature="$(find "$runtime_dir/hypr" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %f\n' 2>/dev/null | sort -nr | awk 'NR == 1 { print $2 }')"
fi

if [ -z "$hypr_signature" ]; then
  exit 0
fi

socket="$runtime_dir/hypr/$hypr_signature/.socket2.sock"
[ -S "$socket" ] || exit 0

# shellcheck disable=SC2016
socat -u "UNIX-CONNECT:$socket" - |
  stdbuf -o0 awk -F '>>|,' '/^activelayout>>/ { print toupper(substr($3, 1, 2)) }'
