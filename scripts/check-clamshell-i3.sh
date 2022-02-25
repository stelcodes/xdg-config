#!/usr/bin/env bash
# Doesn't work currently

if [[ -e /proc/acpi/button/lid/LID/state ]]; then
  lid_state=/proc/acpi/button/lid/LID/state
elif [[ -e /proc/acpi/button/lid/LID0/state ]]; then
  lid_state=/proc/acpi/button/lid/LID0/state
else
  echo "Lid state file could not be found"
  exit 1
fi

if grep -q open $lid_state; then
  xrandr --output "eDP-1" --auto
else
  xrandr --output "eDP-1" --off
fi
