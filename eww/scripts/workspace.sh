#!/usr/bin/env bash
set -euo pipefail

ws() {
  local workspaces=6
  local workspace_icon=()
  local workspace_class=()
  local output=""
  local workspace_data current_workspace windows idx

  workspace_data="$(hyprctl workspaces -j)"
  current_workspace="$(hyprctl activeworkspace -j | jq -r '.id')"

  for ((i = 1; i <= workspaces; i++)); do
    windows="$(jq -r "[.[] | select(.id == ${i})] | .[0]?.windows // 0" <<<"$workspace_data")"
    workspace_icon+=(" ")
    if [[ "$current_workspace" == "$i" ]]; then
      workspace_class+=("visiting")
    elif [[ "$windows" -gt 0 ]]; then
      workspace_class+=("occupied")
    else
      workspace_class+=("free")
    fi
    if [[ "$current_workspace" == "$i" ]]; then
      workspace_icon[i - 1]=" "
    fi
  done

  output="(box :class \"ws\" :halign \"end\" :orientation \"h\" :spacing 5 :space-evenly \"false\""
  for i in {1..6}; do
    idx=$((i - 1))
    output+=" (eventbox :onclick \"hyprctl dispatch workspace $i\" :cursor \"pointer\" :class \"${workspace_class[$idx]}\" (label :text \"${workspace_icon[$idx]}\"))"
  done
  output+=")"
  eww update workspaces-output="$output"
}

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

ws
stdbuf -oL socat -U - "UNIX-CONNECT:$socket" | while read -r line; do
  case "$line" in
    workspace\>\>* | createworkspace\>\>* | destroyworkspace\>\>*)
      ws
      ;;
  esac
done
