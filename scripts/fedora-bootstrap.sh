#! /usr/bin/env bash

sudo systemctl disable cockpit
sudo systemctl disable cockpit.socket

sudo dnf install \
bash bash-completion fish starship \
neovim git tree bat fd-find ripgrep wget neofetch curl htop jq tldr unzip rsync restic trash-cli \
google-noto-sans-mono-fonts google-noto-emoji-color-fonts fontawesome-fonts \
make g++ clojure rust cargo nodejs \
firefox kitty keepassxc dolphin \
torbrowser-launcher qbittorrent \
openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome gnome-keyring \
sway mako xdg-desktop-portal-wlr slurp wl-clipboard wtype  grim wofi wlsunset \
i3 setxkbmap rofi slop maim feh \
kvantum qt5ct brightnessctl papirus-icon-theme libnotify libinput-utils \
wireplumber bluez blueman pavucontrol \
mpv
