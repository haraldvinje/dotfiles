#!/bin/bash

[[ ! -z $(xrandr | grep "DP-2 connected") ]] && source /home/haraldv/.screenlayout/xperitech.sh \
    || ([[ ! -z $(xrandr | grep "HDMI-1 connected") ]] && source /home/haraldv/.screenlayout/kringsja.sh) \
    || xrandr -s 1920x1200
