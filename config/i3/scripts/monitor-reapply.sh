#!/usr/bin/env bash
set -euo pipefail

# Manual monitor/layout recovery (Mod+Shift+o). Not started on hotplug.
# Place = active NetworkManager wifi/ethernet name (SSID or wired profile).
# Layout = autorandr profile from monitor-map, then feh + polybar.
# Workspaces stay where they are.

MAP="${MONITOR_MAP:-$HOME/.config/i3/scripts/monitor-map}"

has_external=0
if xrandr --query | awk '$2 == "connected" {print $1}' | grep -vqE '^(eDP|EDP|LVDS|DSI)'; then
  has_external=1
fi
external_word=no
[ "$has_external" -eq 1 ] && external_word=yes

places() {
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -t -f NAME,TYPE,STATE connection show --active 2>/dev/null \
      | awk -F: '$3 == "activated" && $2 ~ /wireless|802-11|ethernet|802-3/ { print $1 }'
  fi
  command -v iwgetid >/dev/null 2>&1 && iwgetid -r 2>/dev/null || true
}

match_profile() {
  local ext="$1"
  local line place want_ext profile p
  [ -r "$MAP" ] || return 1

  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    [ -z "$line" ] && continue
    IFS='|' read -r place want_ext profile _ <<<"$line"
    [ -n "$place" ] && [ -n "$want_ext" ] && [ -n "$profile" ] || continue
    [ "$want_ext" = "$ext" ] || [ "$want_ext" = "*" ] || continue
    if [ "$place" = "*" ]; then
      printf '%s\n' "$profile"
      return 0
    fi
    while IFS= read -r p; do
      [ -z "$p" ] && continue
      if [ "$p" = "$place" ]; then
        printf '%s\n' "$profile"
        return 0
      fi
    done < <(places | sort -u)
  done < "$MAP"
  return 1
}

# Outputs can stay "disconnected" with an old mode/position; autorandr --change
# may still match a docked profile. Turn those CRTCs off.
disable_stale_outputs() {
  local out
  while IFS= read -r out; do
    [ -n "$out" ] || continue
    xrandr --output "$out" --off || true
  done < <(
    xrandr --query | awk '$2 == "disconnected" {
      for (i = 3; i <= NF; i++) if ($i ~ /^[0-9]+x[0-9]+/) { print $1; break }
    }'
  )
}

apply_profile() {
  local profile="$1"
  if [ "$profile" = "auto" ]; then
    autorandr --change || xrandr --auto || true
  elif autorandr --list 2>/dev/null | grep -qx "$profile"; then
    autorandr --load "$profile" || xrandr --auto || true
  else
    # Named profile missing (e.g. laptop with no EDID setup): do not --change,
    # that re-applies docked when an output is only half-disconnected.
    xrandr --auto || true
  fi
  disable_stale_outputs
}

has_profiles=0
if ls "$HOME/.config/autorandr"/*/config >/dev/null 2>&1; then
  has_profiles=1
fi

if [ "$has_profiles" -eq 1 ] && command -v autorandr >/dev/null 2>&1; then
  chosen="$(match_profile "$external_word" || true)"
  if [ -n "${chosen:-}" ]; then
    apply_profile "$chosen"
  elif [ "$has_external" -eq 1 ]; then
    apply_profile auto
  else
    apply_profile laptop
  fi
else
  xrandr --auto || true
  disable_stale_outputs
fi

# Give X/i3 a moment to settle output geometry.
sleep 2

# Sticky workspaces: do not remap/move existing ones.
feh --no-fehbg --bg-fill --randomize "$HOME/Pictures/Wallpapers/" || true
"$HOME/.config/polybar/launch.sh" || true
