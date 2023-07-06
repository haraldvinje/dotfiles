#!/bin/bash

[[ ! -z $(xrandr | grep "DP-2 connected") ]] && \
    ([[ $(nmcli | grep -i inteno) ]] && source /home/haraldv/.screenlayout/home2.sh) || \
    ([[ $(nmcli | grep -i posten) ]] && source /home/haraldv/.screenlayout/posten.sh) || \
    ([[ $(nmcli | grep -i telia) ]] && source /home/haraldv/.screenlayout/sjusjoen.sh) || \
    ([[ $(nmcli | grep -i vinje) ]] && source /home/haraldv/.screenlayout/korsvollbakken.sh) || \
    source /home/haraldv/.screenlayout/item.sh || \
    xrandr -s 1920x1200
