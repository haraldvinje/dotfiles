killall -q polybar

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload PolybarTony &
  done
else
  polybar --reload PolybarTony &
fi
