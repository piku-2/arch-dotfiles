#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.config/waybar/configs/[TOP] 0-Ja-0 Been modified"
style="$HOME/.config/waybar/style/islands.css"
log="${XDG_STATE_HOME:-$HOME/.local/state}/waybar.log"

mkdir -p "$(dirname "$log")"

pkill -x waybar >/dev/null 2>&1 || true
waybar -c "$config" -s "$style" >"$log" 2>&1 &
