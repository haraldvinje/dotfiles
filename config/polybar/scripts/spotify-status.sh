#!/usr/bin/env bash

player="spotify"

status="$(playerctl --player="$player" status 2>/dev/null)" || exit 0
title="$(playerctl --player="$player" metadata xesam:title 2>/dev/null)"
artist="$(playerctl --player="$player" metadata xesam:artist 2>/dev/null | sed -n '1p')"

# Hide the module when Spotify exists but no track metadata is available.
[ -z "$title" ] && exit 0

if [ -n "$artist" ]; then
  track="$artist - $title"
else
  track="$title"
fi

case "$status" in
  Playing)
    # Show pause as the primary button while actively playing.
    printf "%%{F#9ece6a}%%{T3}%%{T-}   PLAY %%{F-}%s\n" "$track"
    ;;
  Paused)
    # Show play as the primary button while paused.
    printf "%%{F#a8a8a8}%%{T3}%%{T-}   PAUSE%%{F-} %s\n" "$track"
    ;;
  *)
    exit 0
    ;;
esac
