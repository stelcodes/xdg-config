#!/usr/bin/env bash

# DEPRECATED
# No longer in use
exit 1

bullseye_core=(tmux neovim/bookworm firmware-iwlwifi/bookworm udisks2 curl neofetch make gcc vim trash-cli git restic htop bat fd-find ripgrep tldr)
# Missing: starship dust
# sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --bin-dir ~/.local/bin
sudo apt update
sudo apt install ${bullseye_core[*]}

bullseye_desktop=(sway swaylock swayidle kitty wofi wl-clipboard wtype xwayland fonts-noto-color-emoji libinput-tools brightnessctl evince firefox/experimental firmware-linux)
# Missing: wl-sunset rofimoji
# pip install --user rofimoji
# wl-sunset deps: meson libwayland-bin pkg-config cmake wayland-protocols
read -p "Do you want to install desktop packages from bullseye? [Y/n] " input

if [ "$input" == "y" ] || [ "$input" == "Y" ] || [ "$input" == "" ]; then
  sudo apt install ${bullseye_desktop[*]}
else
  echo "Skipping sway packages..."
fi

bullseye_coding=(clojure leiningen nodejs npm python3-pip postgresql)
# Missing: babashka
read -p "Do you want to install coding packages from bullseye? [Y/n] " input

if [ "$input" == "y" ] || [ "$input" == "Y" ] || [ "$input" == "" ]; then
  sudo apt install ${bullseye_coding[*]}
else
  echo "Skipping coding packages..."
fi

# bookworm_pkgs=(neovim firmware-iwlwifi)
