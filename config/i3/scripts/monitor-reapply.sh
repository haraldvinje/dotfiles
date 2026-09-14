#!/usr/bin/env bash
set -euo pipefail

# Apply the layout for this place, then wallpaper + polybar.
# Place = active NetworkManager wifi/ethernet name (SSID or wired profile).
# Layout name in monitor-map is tried as ~/.screenlayout/<name>.sh first,
# then as an autorandr profile. Workspaces stay where they are.

MAP="${MONITOR_MAP:-$HOME/.config/i3/scripts/monitor-map}"
LAYOUTDIR="${HOME}/.screenlayout"

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

# Outputs can stay "disconnected" with an old mode/position. Turn those CRTCs off.
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
  local script="${LAYOUTDIR}/${profile}.sh"

  if [ -f "$script" ]; then
    sh "$script" || true
  elif [ "$profile" = "auto" ]; then
    autorandr --change || xrandr --auto || true
  elif command -v autorandr >/dev/null 2>&1 && autorandr --list 2>/dev/null | grep -qx "$profile"; then
    autorandr --load "$profile" || xrandr --auto || true
  else
    # Named layout missing: do not --change, that can re-apply a docked profile
    # when an output is only half-disconnected.
    xrandr --auto || true
  fi
  disable_stale_outputs
}

chosen="$(match_profile "$external_word" || true)"
if [ -n "${chosen:-}" ]; then
  apply_profile "$chosen"
elif [ "$has_external" -eq 1 ]; then
  apply_profile auto
else
  apply_profile laptop
fi

# Give X/i3 a moment to settle output geometry before bars.
sleep 0.5

# Random wallpapers, wal from the primary's image, then polybar/rofi colors.
if [ -x "$HOME/.scripts/desk" ]; then
  "$HOME/.scripts/desk" theme randomize || true
else
  feh --no-fehbg --bg-fill --randomize "$HOME/Pictures/Wallpapers/" || true
  "$HOME/.config/polybar/launch.sh" || true
fi
