#!/usr/bin/env bash
set -e
brightnessctl set +10%
bri=$(brightnessctl -m | cut -d, -f4 | tr -d "%")
dunstify -a "osd" -u low -r 2594 -t 1000 -h int:value:"$bri" "Brightness" "${bri}%"
