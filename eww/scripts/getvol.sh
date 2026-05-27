#!/usr/bin/env bash

update_volume() {
    local volume mute
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ printf "%d", $2 * 100 }')
    mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

    if [ "$mute" = true ]; then
        eww update volico="󰖁"
        volume="0"
    else
        eww update volico="󰕾"
    fi

    eww update get_vol="$volume"
}

update_volume

pactl subscribe | stdbuf -oL grep --line-buffered "Event 'change' on sink" | while read -r _; do
    update_volume
done
