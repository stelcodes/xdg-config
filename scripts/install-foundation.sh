#!/usr/bin/env bash

bullseye_core=(tmux udisks2 curl vim trash-cli git)
# Missing: starship babashka dust
# sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --bin-dir ~/.local/bin
sudo apt update
sudo apt install ${bullseye_core[*]}

bullseye_sway=(sway kitty wofi wl-clipboard wtype fonts-noto-color-emoji)
# Missing: wl-sunset rofimoji
# pip install --user rofimoji
read -p "Do you want to install sway packages from bullseye? [Y/n] " input

if [ "$input" == "y" ] || [ "$input" == "Y" ] || [ "$input" == "" ]; then
  sudo apt install ${bullseye_sway[*]}
else
  echo "Skipping sway packages..."
fi

bullseye_coding=(clojure nodejs python3-pip)
# Missing: babashka
read -p "Do you want to install coding packages from bullseye? [Y/n] " input

if [ "$input" == "y" ] || [ "$input" == "Y" ] || [ "$input" == "" ]; then
  sudo apt install ${bullseye_coding[*]}
else
  echo "Skipping coding packages..."
fi

# bookworm_pkgs=(neovim)
