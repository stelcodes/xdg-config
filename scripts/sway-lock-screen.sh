#!/usr/bin/env bash

# --indicator-idle-visible causes bad flickering atm
# https://github.com/swaywm/swaylock/issues/223

swaylock \
  --image ~/wallpaper.png \
  --font 'JetBrains Mono' --font-size 14 \
  --line-color 1d212a --text-color 1d212a \
  --inside-color b2caff --ring-color b2caff \
  --inside-clear-color dafd89 --inside-ver-color 4bead2 --inside-wrong-color f05c8e \
  --bs-hl-color ff3c7e --key-hl-color 9bb9fc \
  --ring-ver-color 18eece --ring-wrong-color ff3c7e --ring-clear-color dafd89
