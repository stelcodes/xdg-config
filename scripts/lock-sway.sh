#! /usr/bin/env bash

exec swaylock \
  --daemonize \
  --image ~/wallpaper \
  --indicator-idle-visible \
  --font 'Noto Sans Mono' --font-size 12 \
  --line-color 21222c --text-color 21222c \
  --inside-color 6272a4 --ring-color 6272a4 \
  --inside-clear-color ffffa5 --inside-ver-color bd93f9 --inside-wrong-color ff6e6e \
  --bs-hl-color ff5555 --key-hl-color 50fa7b \
  --ring-ver-color bd93f9 --ring-wrong-color ff5555 --ring-clear-color f1fa8c
