#!/bin/bash

[[ ! -z $(xrandr | grep "DP-2 connected") ]] && ([[ nmcli | grep -i inteno ]]  && source /home/haraldv/.screenlayout/home.sh || source /home/haraldv/.screenlayout/item.sh) \
    || xrandr -s 1920x1200
