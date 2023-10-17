#!/bin/bash

[[ ! -z $(xrandr | grep "DP-2 connected" || xrandr | grep -i "HDMI-1 connected" || xrandr | grep -i "DP-2-3 connected") ]] && \
    ([[ $(nmcli | grep -i vinje) ]] && source /home/haraldv/.screenlayout/korsvollbakken.sh) || \
    ([[ $(nmcli | grep -i posten) ]] && source /home/haraldv/.screenlayout/posten.sh) || \
    ([[ $(nmcli | grep -i telia) ]] && source /home/haraldv/.screenlayout/sjusjoen.sh) || \
    ([[ $(nmcli | grep -i dd) ]] && source /home/haraldv/.screenlayout/spreder.sh) || \
    source /home/haraldv/.screenlayout/item.sh || \
    xrandr -s 1920x1200
