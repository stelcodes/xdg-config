#! /usr/bin/env bash

sudo systemctl disable cockpit
sudo systemctl disable cockpit.socket

sudo dnf install \
bash bash-completion fish starship \
neovim git tree bat fd-find ripgrep wget neofetch curl htop jq tldr unzip rsync restic trash-cli \
google-noto-sans-mono-fonts google-noto-emoji-color-fonts fontawesome-fonts fontawesome5-fonts \
make g++ \
firefox kitty keepassxc dolphin gnome-font-viewer gnome-disk-utility \
torbrowser-launcher qbittorrent \
openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome NetworkManager-tui gnome-keyring \
sway mako xdg-desktop-portal-wlr slurp wl-clipboard wtype  grim wofi wlsunset \
i3 setxkbmap rofi slop maim feh \
kvantum qt5ct brightnessctl papirus-icon-theme libnotify libinput-utils \
wireplumber bluez blueman pavucontrol

# mpv not in main package channel

# Rebuild font cache
fc-cache -f
