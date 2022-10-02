#! /usr/bin/env bash

###############################################################################
# ENABLE RPM FUSION

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

###############################################################################
# INSTALL CORE PACKAGES

INSTALL_CORE=~/.config/scripts/install-fedora-core-packages.sh
if test -f $INSTALL_CORE; then
  source $INSTALL_CORE
else
  echo "Core package installation script not found"
fi

sudo dnf groupupdate core
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video

###############################################################################
# INSTALL WORKSTATION PACKAGES

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
wev \
setxkbmap \
rofi \
rofimoji \
slop \
i3-gaps \
xdotool \
xsel \
xclip \
redshift \
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
pavucontrol \
audacious \
mpv

###############################################################################
# REBUILD FONT CACHE

fc-cache -r

###############################################################################
# INSTALL NIX PACKAGES

if test $(command -v nix-env); then
  nix-env -iA nixpkgs.i3status-rust
else
  echo "Skipping Nix packages, Nix not installed"
fi

###############################################################################
# INSTALL FLATPAK PACKAGES

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
