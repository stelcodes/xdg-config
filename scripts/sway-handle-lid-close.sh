#!/usr/bin/env bash

if [[ -z $(swaymsg -t get_outputs | grep unfocused) ]]; then
  playerctl --all-players pause
fi

swaymsg output eDP-1 disable
