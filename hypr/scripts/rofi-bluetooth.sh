#!/usr/bin/env bash
set -euo pipefail

rofi_menu=(rofi -dmenu -i -p "bluetooth")

show_error() {
  rofi -e "$1" >/dev/null 2>&1 || printf '%s\n' "$1" >&2
}

device_menu() {
  bluetoothctl devices |
    awk '
      /^Device/ {
        mac = $2
        $1 = ""
        $2 = ""
        sub(/^  */, "")
        if ($0 != "") {
          print $0 " (" mac ")"
        }
      }
    ' |
    sort -u |
    "${rofi_menu[@]}" -p "$1"
}

connected_device_menu() {
  bluetoothctl devices |
    while read -r _ mac name; do
      if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        printf '%s (%s)\n' "$name" "$mac"
      fi
    done |
    sort -u |
    "${rofi_menu[@]}" -p "$1"
}

selected_mac() {
  selected="$1"
  mac="${selected##* (}"
  printf '%s\n' "${mac%)}"
}

scan_devices() {
  bluetoothctl power on >/dev/null
  timeout 4s bluetoothctl scan on >/dev/null 2>&1 || true
  bluetoothctl scan off >/dev/null 2>&1 || true
}

if pidof rofi >/dev/null; then
  pkill rofi
fi

powered="$(bluetoothctl show | awk -F: '/Powered/ { gsub(/^[ \t]+/, "", $2); print $2; exit }')"

menu_items=()

if [ "$powered" = "yes" ]; then
  menu_items+=("Turn Bluetooth off")
  menu_items+=("Scan devices")
  menu_items+=("Connect device")
  menu_items+=("Disconnect device")
  menu_items+=("Trust device")
else
  menu_items+=("Turn Bluetooth on")
fi

choice="$(printf '%s\n' "${menu_items[@]}" | "${rofi_menu[@]}")"

case "$choice" in
  "Turn Bluetooth on")
    bluetoothctl power on >/dev/null
    ;;
  "Turn Bluetooth off")
    bluetoothctl power off >/dev/null
    ;;
  "Scan devices")
    scan_devices
    device_menu "devices" >/dev/null
    ;;
  "Connect device")
    scan_devices
    selected="$(device_menu "connect")"

    if [ -z "$selected" ]; then
      exit 0
    fi

    mac="$(selected_mac "$selected")"
    bluetoothctl connect "$mac" >/dev/null || show_error "Failed to connect: $selected"
    ;;
  "Disconnect device")
    selected="$(connected_device_menu "disconnect")"

    if [ -z "$selected" ]; then
      exit 0
    fi

    mac="$(selected_mac "$selected")"
    bluetoothctl disconnect "$mac" >/dev/null || show_error "Failed to disconnect: $selected"
    ;;
  "Trust device")
    scan_devices
    selected="$(device_menu "trust")"

    if [ -z "$selected" ]; then
      exit 0
    fi

    mac="$(selected_mac "$selected")"
    bluetoothctl trust "$mac" >/dev/null || show_error "Failed to trust: $selected"
    ;;
esac
