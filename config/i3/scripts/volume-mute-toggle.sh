#!/usr/bin/env bash
set -e
pactl set-sink-mute @DEFAULT_SINK@ toggle
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | sed -n "s|Mute: ||p")
if [ "$muted" = "yes" ]; then
  dunstify -a "osd" -u low -r 2593 -t 1000 -h int:value:0 "Volume" "Muted"
else
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]+%' | head -n1 | tr -d '%')
  [ -z "$vol" ] && vol=0
  dunstify -a "osd" -u low -r 2593 -t 1000 -h int:value:"$vol" "Volume" "${vol}%"
fi
