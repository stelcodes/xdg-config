#!/usr/bin/env bash
set -e

USER_FONTS_DIR="$HOME/.local/share/fonts"
JETBRAINS_STORAGE="$HOME/.config/files/JetBrains Mono Nerd Font"
JETBRAINS_INSTALL="$USER_FONTS_DIR/JetBrains Mono Nerd Font"

mkdir -p "$USER_FONTS_DIR"

if test -d "$JETBRAINS_INSTALL"; then
  echo "JetBrains Mono Nerd Font already installed"
  exit 1
fi

rsync --archive "$JETBRAINS_STORAGE" "$JETBRAINS_INSTALL"
fc-cache -v
