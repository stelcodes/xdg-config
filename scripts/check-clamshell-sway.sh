#!/usr/bin/env bash

if [[ -e /proc/acpi/button/lid/LID/state ]]; then
  lid_state=/proc/acpi/button/lid/LID/state
elif [[ -e /proc/acpi/button/lid/LID0/state ]]; then
  lid_state=/proc/acpi/button/lid/LID0/state
else
  echo "Lid state file could not be found"
  exit 1
fi

if grep -q open $lid_state; then
  swaymsg output "eDP-1" enable
else
  swaymsg output "eDP-1" disable
fi
