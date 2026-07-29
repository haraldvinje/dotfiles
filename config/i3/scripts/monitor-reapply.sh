#!/usr/bin/env bash
set -euo pipefail

# Manual monitor/layout recovery path.
has_profiles=0
if ls "$HOME/.config/autorandr"/*/config >/dev/null 2>&1; then
  has_profiles=1
fi

has_external=0
if xrandr --query | awk '$2 == "connected" {print $1}' | grep -vqE '^(eDP|EDP|LVDS|DSI)'; then
  has_external=1
fi

if [ "$has_profiles" -eq 1 ]; then
  if [ "$has_external" -eq 1 ]; then
    autorandr --load docked || autorandr --change || true
  else
    autorandr --load laptop || autorandr --change || true
  fi
else
  xrandr --auto || true
fi

# Give X/i3 a moment to settle output geometry.
sleep 2

# Sticky workspace policy:
# Do not remap/move existing workspaces automatically.
feh --no-fehbg --bg-fill --randomize "$HOME/Pictures/Wallpapers/" || true
"$HOME/.config/polybar/launch.sh" || true
