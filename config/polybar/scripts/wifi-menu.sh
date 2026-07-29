#!/usr/bin/env bash
if command -v nm-connection-editor >/dev/null 2>&1; then
  nohup nm-connection-editor >/dev/null 2>&1 &
elif command -v nmtui >/dev/null 2>&1; then
  if command -v terminator >/dev/null 2>&1; then
    nohup terminator -e nmtui >/dev/null 2>&1 &
  elif command -v alacritty >/dev/null 2>&1; then
    nohup alacritty -e nmtui >/dev/null 2>&1 &
  else
    nohup xterm -e nmtui >/dev/null 2>&1 &
  fi
fi
