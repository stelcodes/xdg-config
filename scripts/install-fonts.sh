#!/usr/bin/env bash

set -ex

FONTS_DIR="$HOME/.local/share/fonts"
JETBRAINS_ARCHIVE="$HOME/.config/files/JetBrainsMonoNerdFont.tar.gz"
JETBRAINS_INSTALL="$FONTS_DIR/JetBrains Mono Nerd Font"

mkdir -p "$FONTS_DIR"

if [[ -d $JETBRAINS_INSTALL ]]; then
  echo "JetBrains Mono Nerd Font already installed"
else
  echo "Extracting font $JETBRAINS_ARCHIVE"
  tar xvf "$JETBRAINS_ARCHIVE" --directory="$FONTS_DIR"
fi

echo "Rebuilding font cache..."
fc-cache -f
