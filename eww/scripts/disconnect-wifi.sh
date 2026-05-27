#!/usr/bin/env bash
set -euo pipefail

device=$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2 == "wifi" && $3 == "connected" { print $1; exit }')

if [ -n "$device" ]; then
  nmcli device disconnect "$device"
fi
