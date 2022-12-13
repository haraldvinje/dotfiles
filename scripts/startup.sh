#!/bin/bash

sleep 1
sh /home/haraldv/.scripts/resolve-screens.sh
sleep 1
sh /home/haraldv/.config/polybar/launch-new.sh --forest
sh /home/haraldv/.scripts/swap-caps-escape.sh
feh --bg-scale --randomize /home/haraldv/Pictures/wallpapers/
