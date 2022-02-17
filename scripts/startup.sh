#!/bin/bash

sleep 1
sh /home/haraldv/.scripts/resolve-screens.sh
sleep 1
sh /home/haraldv/.config/polybar/launch.sh 
xmodmap /home/haraldv/.Xmodmap
feh --bg-scale --randomize /home/haraldv/Pictures/Wallpapers/
