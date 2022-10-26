#!/usr/bin/env bash

# --indicator-idle-visible causes bad flickering atm
# https://github.com/swaywm/swaylock/issues/223

swaylock \
  --image ~/wallpaper \
  --font 'JetBrains Mono' --font-size 14 \
  --line-color 21222c --text-color 21222c \
  --inside-color 6272a4 --ring-color 6272a4 \
  --inside-clear-color ffffa5 --inside-ver-color bd93f9 --inside-wrong-color ff6e6e \
  --bs-hl-color ff5555 --key-hl-color 50fa7b \
  --ring-ver-color bd93f9 --ring-wrong-color ff5555 --ring-clear-color f1fa8c
