#!/usr/bin/env bash

playerctl --all-players pause
# Use dpms off/on when sleeping because just using enable/disable flickers session screen when locked
# https://github.com/swaywm/swaylock/issues/185
swaymsg output "*" dpms off
source ~/.config/scripts/sway-lock-screen.sh
