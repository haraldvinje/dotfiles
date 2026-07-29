#!/usr/bin/env bash

killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.2; done

# Wait until i3 IPC is ready (prevents stale socket errors).
for _ in {1..30}; do
  if i3-msg -t get_version >/dev/null 2>&1; then
    break
  fi
  sleep 0.2
done

I3SOCK="$(i3 --get-socketpath 2>/dev/null || true)"
if [ -n "$I3SOCK" ]; then
  export I3SOCK
fi

DEFAULT_IFACE="$(ip route | awk '/^default/ {print $5; exit}')"
export DEFAULT_IFACE

# Launch one bar per active i3 output.
# Keep tray only on a preferred monitor (internal, else primary, else first).
mapfile -t connected_monitors < <(
  i3-msg -t get_outputs | python -c '
import json, sys
for out in json.load(sys.stdin):
    if out.get("active"):
        print(out["name"])
'
)

# Fallbacks when i3 output query isn't available yet.
if [ "${#connected_monitors[@]}" -eq 0 ]; then
  mapfile -t connected_monitors < <(polybar --list-monitors 2>/dev/null | awk -F: '{print $1}')
fi
if [ "${#connected_monitors[@]}" -eq 0 ]; then
  mapfile -t connected_monitors < <(xrandr --query | awk '$2 == "connected" {print $1}')
fi

if [ "${#connected_monitors[@]}" -eq 0 ]; then
  polybar -c "$HOME/.config/polybar/config.ini" main &
else
  tray_monitor=""
  tray_monitor="$(printf '%s\n' "${connected_monitors[@]}" | awk '/^(eDP|EDP|LVDS|DSI)/ {print; exit}')"
  if [ -z "$tray_monitor" ]; then
    tray_monitor="$(
      i3-msg -t get_outputs | python -c '
import json, sys
for out in json.load(sys.stdin):
    if out.get("active") and out.get("primary"):
        print(out["name"])
        break
'
    )"
  fi
  if [ -z "$tray_monitor" ]; then
    tray_monitor="${connected_monitors[0]}"
  fi

  for monitor in "${connected_monitors[@]}"; do
    if [ "$monitor" = "$tray_monitor" ]; then
      MONITOR="$monitor" TRAY_POSITION="right" polybar -c "$HOME/.config/polybar/config.ini" main &
    else
      MONITOR="$monitor" TRAY_POSITION="none" polybar -c "$HOME/.config/polybar/config.ini" main &
    fi
  done
fi

# Restart NetworkManager tray applet after bar is up.
sleep 1
killall -q nm-applet
nohup nm-applet >/dev/null 2>&1 &
