#! /usr/bin/env bash

SERVER_BOOTSTRAP_SCRIPT=~/.config/scripts/fedora-server-bootstrap.sh
if test -e $SERVER_BOOTSTRAP_SCRIPT; then
  source ~/.config/scripts/fedora-server-bootstrap.sh
else
  echo "Skipping server bootstrap script"
fi

sudo dnf install \
google-noto-sans-mono-fonts \
google-noto-emoji-color-fonts \
fontawesome-fonts fontawesome5-fonts \
jetbrains-mono-fonts \
jetbrains-mono-nl-fonts \
firefox \
kitty \
keepassxc \
dolphin \
gnome-font-viewer \
gnome-disk-utility \
torbrowser-launcher \
qbittorrent \
vlc \
openvpn \
NetworkManager-openvpn \
NetworkManager-openvpn-gnome \
NetworkManager-tui \
gnome-keyring \
sway \
mako \
xdg-desktop-portal-wlr \
slurp \
wl-clipboard \
wtype \
grim \
wofi \
wlsunset \
i3 \
setxkbmap \
rofi \
slop \
maim \
feh \
kvantum \
qt5ct \
brightnessctl \
papirus-icon-theme \
libnotify \
libinput-utils \
wireplumber \
bluez \
blueman \
pavucontrol

# Separate RPM Fusion packages so they can fail by themselves if RPM Fusion has not been installed
sudo dnf install \
mpv
# Proprietary Codecs
# https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia

# Rebuild font cache
fc-cache -r

if command -v nix-env; then
  nix-env -iA nixpkgs.i3status-rust
else
  echo "Skipping Nix packages, Nix not installed"
fi
