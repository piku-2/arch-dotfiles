#!/bin/bash

set -euo pipefail

get_cursor_eww_screen() {
    if ! command -v hyprctl >/dev/null 2>&1; then
        return 1
    fi

    local cursor x y
    cursor="$(hyprctl cursorpos 2>/dev/null || true)"
    x="${cursor%%,*}"
    y="${cursor##*,}"

    [[ -z "${x}" || -z "${y}" ]] && return 1

    hyprctl -j monitors 2>/dev/null | python -c 'import json,sys
x=int(sys.argv[1]); y=int(sys.argv[2])
mons=json.load(sys.stdin)
for m in mons:
    mx,my,mw,mh = int(m.get("x",0)), int(m.get("y",0)), int(m.get("width",0)), int(m.get("height",0))
    if mx <= x < mx+mw and my <= y < my+mh:
        print(m.get("model") or "")
        sys.exit(0)
print((mons[0].get("model") or "") if mons else "")
' "${x}" "${y}" | head -n 1
}

eww_screen="$(get_cursor_eww_screen || true)"
safe_screen="${eww_screen//[^A-Za-z0-9._-]/_}"
window_id="wifictl_${safe_screen:-default}"

active_ids="$(/usr/bin/eww active-windows | awk -F': ' '$2 == "wifictl" {print $1}')"

if echo "${active_ids}" | grep -qx "${window_id}"; then
    /usr/bin/eww update wifictlrev=false && /usr/bin/eww update wificonfigrev=false
    (sleep 0.2 && /usr/bin/eww close "${window_id}") &
    exit 0
fi

if [[ -n "${active_ids}" ]]; then
    /usr/bin/eww update wifictlrev=false && /usr/bin/eww update wificonfigrev=false
    while IFS= read -r id; do
        [[ -z "${id}" ]] && continue
        /usr/bin/eww close "${id}" || true
    done <<< "${active_ids}"
fi

if [[ -n "${eww_screen}" ]]; then
    /usr/bin/eww open wifictl --id "${window_id}" --screen "${eww_screen}" && /usr/bin/eww update wifictlrev=true
else
    /usr/bin/eww open wifictl --id "${window_id}" && /usr/bin/eww update wifictlrev=true
fi
