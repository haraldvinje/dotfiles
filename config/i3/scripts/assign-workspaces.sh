#!/usr/bin/env bash
set -euo pipefail

# Assign workspaces round-robin across active outputs.
# Preference order:
#   1) Internal panel (eDP/LVDS/DSI) if present
#   2) Primary output
#   3) Remaining outputs in reported order

mapfile -t connected_outputs < <(
  i3-msg -t get_outputs | python -c '
import json, sys
for out in json.load(sys.stdin):
    if out.get("active"):
        flags = []
        if out.get("primary"):
            flags.append("primary")
        print(out["name"] + (" " + " ".join(flags) if flags else ""))
'
)

if [ "${#connected_outputs[@]}" -eq 0 ]; then
  exit 0
fi

internal_output=""
primary_output=""
remaining_outputs=()

for line in "${connected_outputs[@]}"; do
  output="${line%% *}"

  case "$output" in
    eDP*|EDP*|LVDS*|DSI*)
      if [ -z "$internal_output" ]; then
        internal_output="$output"
      fi
      ;;
  esac

  case "$line" in
    *" primary"*)
      if [ -z "$primary_output" ]; then
        primary_output="$output"
      fi
      ;;
  esac
done

ordered_outputs=()

if [ -n "$internal_output" ]; then
  ordered_outputs+=("$internal_output")
elif [ -n "$primary_output" ]; then
  ordered_outputs+=("$primary_output")
fi

for line in "${connected_outputs[@]}"; do
  output="${line%% *}"
  skip=0
  for picked in "${ordered_outputs[@]}"; do
    if [ "$output" = "$picked" ]; then
      skip=1
      break
    fi
  done
  if [ "$skip" -eq 0 ]; then
    remaining_outputs+=("$output")
  fi
done

for output in "${remaining_outputs[@]}"; do
  ordered_outputs+=("$output")
done

workspace_count=10
output_count="${#ordered_outputs[@]}"

# Preserve currently focused workspace name.
current_workspace="$(
  i3-msg -t get_workspaces | python -c '
import json, sys
for ws in json.load(sys.stdin):
    if ws.get("focused"):
        print(ws.get("name", "1"))
        break
'
)"
[ -z "$current_workspace" ] && current_workspace="1"

for ((workspace=1; workspace<=workspace_count; workspace++)); do
  output_index=$(( (workspace - 1) % output_count ))
  output="${ordered_outputs[$output_index]}"
  i3-msg "workspace number ${workspace}; move workspace to output ${output}" >/dev/null
done

# Return focus to the workspace that was focused before reassignment.
i3-msg "workspace ${current_workspace}" >/dev/null
