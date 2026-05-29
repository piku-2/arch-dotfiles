#!/usr/bin/env bash
set -euo pipefail

rofi_menu=(rofi -dmenu -i)

show_error() {
  rofi -e "$1" >/dev/null 2>&1 || printf '%s\n' "$1" >&2
}

close_existing_rofi() {
  if pidof rofi >/dev/null; then
    pkill rofi
  fi
}

volume_percent() {
  wpctl get-volume "$1" |
    awk '
      {
        percent = int(($2 * 100) + 0.5)
        muted = index($0, "MUTED") ? " muted" : ""
        print percent "%" muted
      }
    '
}

volume_bar() {
  local value="${1%%%*}"
  local filled=$((value / 10))
  local empty=$((10 - filled))
  local bar=""

  for ((i = 0; i < filled; i++)); do
    bar="${bar}█"
  done

  for ((i = 0; i < empty; i++)); do
    bar="${bar}░"
  done

  printf '%s\n' "$bar"
}

node_description() {
  local target="$1"

  wpctl inspect "$target" 2>/dev/null |
    awk -F' = ' '
      /node.description/ {
        gsub(/"/, "", $2)
        print $2
        exit
      }
    '
}

node_name() {
  local id="$1"

  wpctl inspect "$id" 2>/dev/null |
    awk -F' = ' '
      /node.name/ {
        gsub(/"/, "", $2)
        print $2
        exit
      }
    '
}

choose_sink() {
  wpctl status |
    awk '/Sinks:/,/Sources:/' |
    sed -nE 's/.*[ *]([0-9]+)\. (.*) \[vol.*/\2 (\1)/p' |
    "${rofi_menu[@]}" -p "output"
}

choose_source() {
  wpctl status |
    awk '/Sources:/,/Filters:/' |
    sed -nE 's/.*[ *]([0-9]+)\. (.*) \[vol.*/\2 (\1)/p' |
    "${rofi_menu[@]}" -p "microphone"
}

selected_id() {
  local selected="$1"
  local id="${selected##* (}"
  printf '%s\n' "${id%)}"
}

move_sink_inputs() {
  local sink_name="$1"

  pactl list short sink-inputs 2>/dev/null |
    awk '{ print $1 }' |
    while read -r input; do
      pactl move-sink-input "$input" "$sink_name" >/dev/null 2>&1 || true
    done
}

move_source_outputs() {
  local source_name="$1"

  pactl list short source-outputs 2>/dev/null |
    awk '{ print $1 }' |
    while read -r output; do
      pactl move-source-output "$output" "$source_name" >/dev/null 2>&1 || true
    done
}

set_percent() {
  local target="$1"
  local prompt="$2"
  local value

  value="$(printf '' | "${rofi_menu[@]}" -p "$prompt")"

  if [ -z "$value" ]; then
    return
  fi

  case "$value" in
    *[!0-9]*)
      show_error "Enter a number from 0 to 100"
      return
      ;;
  esac

  if [ "$value" -lt 0 ] || [ "$value" -gt 100 ]; then
    show_error "Enter a number from 0 to 100"
    return
  fi

  wpctl set-volume -l 1 "$target" "${value}%"
}

main_menu() {
  local sink_volume source_volume sink_bar source_bar sink_desc source_desc message

  sink_volume="$(volume_percent @DEFAULT_AUDIO_SINK@)"
  source_volume="$(volume_percent @DEFAULT_AUDIO_SOURCE@)"
  sink_bar="$(volume_bar "$sink_volume")"
  source_bar="$(volume_bar "$source_volume")"
  sink_desc="$(node_description @DEFAULT_AUDIO_SINK@)"
  source_desc="$(node_description @DEFAULT_AUDIO_SOURCE@)"

  if [ -z "$sink_desc" ]; then
    sink_desc="Default output"
  fi

  if [ -z "$source_desc" ]; then
    source_desc="Default microphone"
  fi

  message="Output: ${sink_desc} ${sink_volume} [${sink_bar}] | Mic: ${source_desc} ${source_volume} [${source_bar}]"

  printf '%s\n' \
    "Output +5%" \
    "Output -5%" \
    "Set output volume..." \
    "Toggle output mute" \
    "Select output device..." \
    "Microphone +5%" \
    "Microphone -5%" \
    "Set microphone volume..." \
    "Toggle microphone mute" \
    "Select microphone device..." \
    "Open pavucontrol" \
    "Close" |
    "${rofi_menu[@]}" -p "audio" -mesg "$message" -theme-str 'listview { lines: 12; } window { width: 46%; }'
}

close_existing_rofi

while true; do
  choice="$(main_menu)"

  case "$choice" in
    "Output +5%")
      wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      ;;
    "Output -5%")
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      ;;
    "Set output volume...")
      set_percent @DEFAULT_AUDIO_SINK@ "output %"
      ;;
    "Toggle output mute")
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      ;;
    "Select output device...")
      selected="$(choose_sink)"

      if [ -n "$selected" ]; then
        id="$(selected_id "$selected")"
        wpctl set-default "$id"
        sink_name="$(node_name "$id")"

        if [ -n "$sink_name" ]; then
          move_sink_inputs "$sink_name"
        fi
      fi
      ;;
    "Microphone +5%")
      wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%+
      ;;
    "Microphone -5%")
      wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-
      ;;
    "Set microphone volume...")
      set_percent @DEFAULT_AUDIO_SOURCE@ "microphone %"
      ;;
    "Toggle microphone mute")
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      ;;
    "Select microphone device...")
      selected="$(choose_source)"

      if [ -n "$selected" ]; then
        id="$(selected_id "$selected")"
        wpctl set-default "$id"
        source_name="$(node_name "$id")"

        if [ -n "$source_name" ]; then
          move_source_outputs "$source_name"
        fi
      fi
      ;;
    "Open pavucontrol")
      pavucontrol &
      exit 0
      ;;
    "Close" | "")
      exit 0
      ;;
  esac
done
