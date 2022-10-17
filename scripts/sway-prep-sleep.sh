#!/usr/bin/env bash

playerctl --all-players pause
swaymsg output "*" disable
source ~/.config/scripts/sway-lock-screen.sh
