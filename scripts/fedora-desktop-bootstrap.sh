#! /usr/bin/env bash

source ./fedora-server-bootstrap.sh

sudo dnf install \
google-noto-sans-mono-fonts google-noto-emoji-color-fonts fontawesome-fonts fontawesome5-fonts \
firefox kitty keepassxc dolphin gnome-font-viewer gnome-disk-utility \
torbrowser-launcher qbittorrent \
openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome NetworkManager-tui gnome-keyring \
sway mako xdg-desktop-portal-wlr slurp wl-clipboard wtype  grim wofi wlsunset \
i3 setxkbmap rofi slop maim feh \
kvantum qt5ct brightnessctl papirus-icon-theme libnotify libinput-utils \
wireplumber bluez blueman pavucontrol

# Separate RPM Fusion packages so they can fail by themselves if RPM Fusion has not been installed
sudo dnf install mpv

# Rebuild font cache
fc-cache -r
