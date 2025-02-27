#!/bin/bash

[[ ! -z $(xrandr | grep "DP2 connected" || xrandr | grep -i "HDMI1 connected" || xrandr | grep -i "DP3 connected") ]] && \
    ([[ $(nmcli | grep -i vinjelarsennett) ]] && source /home/haraldv/.screenlayout/home.sh) || \
    ([[ $(nmcli | grep -i vinjenett) ]] && source /home/haraldv/.screenlayout/korsvollbakken.sh) || \
    ([[ $(nmcli | grep -i datek) ]] && source /home/haraldv/.screenlayout/datek.sh) || \
    ([[ $(nmcli | grep -i telia) ]] && source /home/haraldv/.screenlayout/sjusjoen.sh) || \
    ([[ $(nmcli | grep -i slottsfjell) ]] && source /home/haraldv/.screenlayout/hogevarde.sh) || \
    ([[ $(nmcli | grep -i dd) ]] && source /home/haraldv/.screenlayout/spreder.sh) || \
    source /home/haraldv/.screenlayout/item.sh || \
    xrandr -s 1920x1200
