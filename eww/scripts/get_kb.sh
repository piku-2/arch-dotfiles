#!/usr/bin/env bash

runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
HYPRLAND_SIGNATURE_ACTUAL=$(ls -td "$runtime_dir"/hypr/*/ 2>/dev/null | head -n1 | xargs basename)

socat -u UNIX-CONNECT:"$runtime_dir/hypr/$HYPRLAND_SIGNATURE_ACTUAL/.socket2.sock" - |
    stdbuf -o0 awk -F '>>|,' '/^activelayout>>/ { print toupper(substr($3, 1, 2)) }'
