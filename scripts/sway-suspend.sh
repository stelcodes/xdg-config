#!/usr/bin/env bash

if [[ $(cat /sys/class/power_supply/ACAD/online) = "0" && $(playerctl status) != "Playing" ]]; then
  # If not plugged in and not playing media, suspend-then-hibernate to conserve battery power
  systemctl suspend-then-hibernate
else
  # Restart swayidle timer
  systemctl --user restart swayidle
fi
