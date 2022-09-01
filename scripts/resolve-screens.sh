#!/bin/bash

[[ ! -z $(xrandr | grep "DP-2 connected") ]] && source /home/haraldv/.screenlayout/item.sh \
    || xrandr -s 1920x1200
