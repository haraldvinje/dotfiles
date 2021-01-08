killall -q polybar

sleep 2
WORKSPACE_NUMBER=1

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
    i3-msg "workspace ${WORKSPACE_NUMBER}, move"
  done
else
  polybar --reload top &
fi
