#! /usr/bin/env bash

set -ex

###############################################################################
# ENABLE RPM FUSION

sudo dnf install --assumeyes https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

###############################################################################
# INSTALL CORE PACKAGES

INSTALL_CORE=~/.config/scripts/install-fedora-core-packages.sh
if [[ -f $INSTALL_CORE ]]; then
  source $INSTALL_CORE
else
  echo "Core package installation script not found"
fi

###############################################################################
# INSTALL WORKSTATION PACKAGES

sudo dnf install --assumeyes \
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
bemenu \
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
mpv \
vlc \
lxpolkit \
ffmpeg-libs \
libimobiledevice \
playerctl \
# END

# Music Production

# ChowDSP copr repo is not working :(
# sudo dnf copr enable --assumeyes patrickl/ChowDSP
# sudo dnf install --assumeyes \
#   ChowMatrix \
#   ChowTapeModel \
#   ChowKick \
#   ChowPhaser \
#   # END

sudo dnf install --assumeyes \
  qtractor \
  ardour6 \
  Carla \
  lv2-calf-plugins-gui \
  ladspa-autotalent-plugins \
  lsp-plugins-lv2 \
  lv2-zam-plugins \
  lv2-synthv1 \
  lv2-amsynth-plugin \
  # END

# Remove stuff installed by default
sudo dnf remove --assumeyes \
  gnome-software \
  # END

###############################################################################
# UPDATE DNF GROUPS

sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin --assumeyes
sudo dnf groupupdate core --assumeyes
sudo dnf groupupdate sound-and-video --assumeyes

###############################################################################
# REBUILD FONT CACHE

fc-cache -r

###############################################################################
# INSTALL NIX PACKAGES

if [[ -x $(command -v nix-env) ]]; then
  nix-env --install --prebuilt-only --preserve-installed --attr \
    nixpkgs.i3status-rust \
    nixpkgs.babashka \
    nixpkgs.clojure-lsp \
    nixpkgs.sumneko-lua-language-server \
  # END
else
  echo "Skipping Nix packages, Nix not installed"
fi

###############################################################################
# INSTALL FLATPAK PACKAGES

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

flatpak install flathub org.signal.Signal
