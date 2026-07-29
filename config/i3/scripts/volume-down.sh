#!/usr/bin/env bash
set -e
pactl set-sink-volume @DEFAULT_SINK@ -5%
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]+%' | head -n1 | tr -d '%')
[ -z "$vol" ] && vol=0
dunstify -a "osd" -u low -r 2593 -t 1000 -h int:value:"$vol" "Volume" "${vol}%"
