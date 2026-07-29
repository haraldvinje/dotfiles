#!/usr/bin/env bash
set -euo pipefail

# Poll monitor state and re-apply layout/bar/workspaces when it changes.
state_file="/tmp/i3-monitor-state-${USER}"
log_file="/tmp/i3-monitor-watch.log"

get_state() {
  # Only track which outputs are connected (not geometry tokens that can flap).
  xrandr --query | awk '$2 == "connected" {print $1}' | sort | tr '\n' '|'
}

apply_layout() {
  echo "[$(date '+%F %T')] change detected -> reapply" >> "$log_file"
  "$HOME/.config/i3/scripts/monitor-reapply.sh" || true
}

current_state="$(get_state || true)"
printf '%s' "$current_state" > "$state_file"
echo "[$(date '+%F %T')] watcher start state=${current_state}" >> "$log_file"

while true; do
  sleep 2
  new_state="$(get_state || true)"
  old_state="$(cat "$state_file" 2>/dev/null || true)"

  if [ "$new_state" != "$old_state" ]; then
    echo "[$(date '+%F %T')] state ${old_state} -> ${new_state}" >> "$log_file"
    printf '%s' "$new_state" > "$state_file"
    apply_layout
  fi
done
