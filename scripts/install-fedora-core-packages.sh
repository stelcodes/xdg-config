#! /usr/bin/env bash

set -ex

###############################################################################
# INSTALL CORE PACKAGES

sudo dnf install \
bash \
bash-completion \
fish \
starship \
tmux \
neovim \
git \
tree \
bat \
fd-find \
ripgrep \
wget \
neofetch \
curl \
htop \
jq \
tldr \
unzip \
rsync \
restic \
trash-cli \
make \
gcc \
g++ \
entr \
git-delta \
yt-dlp \
fzf \
entr \
git-delta \
unrar \
direnv \
fzf \
dua-cli \
rlwrap \
ShellCheck \
powertop \
mediainfo \
exa \
nnn \
#END

if [[ -x $(command -v nix-env) ]]; then
  nix-env --install --prebuilt-only --attr \
    nixpkgs.du-dust \
    # END
else
  echo "Skipping nix packages, Nix not installed"
fi

