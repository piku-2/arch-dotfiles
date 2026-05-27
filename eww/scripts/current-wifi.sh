#!/usr/bin/env bash
set -euo pipefail

row="$(
  nmcli -t -f ACTIVE,SIGNAL,SSID dev wifi |
    awk -F: '$1 == "yes" {
      ssid = substr($0, length($1 FS $2 FS) + 1)
      print $2 "\t" ssid
      exit
    }'
)"

if [[ -z "$row" ]]; then
  jq -nc '{icon: "睊", ssid: "Disconnected", strength: 0}'
  exit 0
fi

signal="${row%%$'\t'*}"
ssid="${row#*$'\t'}"

jq -nc \
  --arg icon "直" \
  --arg ssid "${ssid^^}" \
  --argjson strength "${signal:-0}" \
  '{icon: $icon, ssid: $ssid, strength: $strength}'
