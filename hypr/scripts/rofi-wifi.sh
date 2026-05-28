#!/usr/bin/env bash
set -euo pipefail

rofi_menu=(rofi -dmenu -i -p "wifi")

show_error() {
  rofi -e "$1" >/dev/null 2>&1 || printf '%s\n' "$1" >&2
}

if pidof rofi >/dev/null; then
  pkill rofi
fi

wifi_state="$(nmcli -t -f WIFI general 2>/dev/null || printf 'unknown')"
wifi_device="$(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2 == "wifi" { print $1; exit }')"
active_connection="$(nmcli -t -f NAME,TYPE connection show --active | awk -F: '$2 == "802-11-wireless" { print $1; exit }')"

menu_items=()

if [ "$wifi_state" = "enabled" ]; then
  menu_items+=("Turn Wi-Fi off")
  menu_items+=("Rescan networks")
  menu_items+=("Connect network")

  if [ -n "$active_connection" ] && [ -n "$wifi_device" ]; then
    menu_items+=("Disconnect ${active_connection}")
  fi
else
  menu_items+=("Turn Wi-Fi on")
fi

choice="$(printf '%s\n' "${menu_items[@]}" | "${rofi_menu[@]}")"

case "$choice" in
  "Turn Wi-Fi on")
    nmcli radio wifi on
    ;;
  "Turn Wi-Fi off")
    nmcli radio wifi off
    ;;
  "Rescan networks")
    nmcli device wifi rescan >/dev/null 2>&1 || true
    ;;
  "Connect network")
    nmcli radio wifi on
    nmcli device wifi rescan >/dev/null 2>&1 || true

    ssid="$(
      nmcli -t -f SSID device wifi list --rescan yes |
        sed '/^$/d' |
        awk '!seen[$0]++' |
        "${rofi_menu[@]}" -p "network"
    )"

    if [ -z "$ssid" ]; then
      exit 0
    fi

    if nmcli device wifi connect "$ssid"; then
      exit 0
    fi

    password="$(printf '' | rofi -dmenu -password -p "password")"

    if [ -z "$password" ]; then
      exit 0
    fi

    nmcli device wifi connect "$ssid" password "$password" || show_error "Failed to connect: $ssid"
    ;;
  Disconnect*)
    if [ -n "$wifi_device" ]; then
      nmcli device disconnect "$wifi_device"
    else
      show_error "Wi-Fi device was not found"
    fi
    ;;
esac
