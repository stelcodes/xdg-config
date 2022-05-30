#! /usr/bin/env bash

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
fzf \
entr \
git-delta \
yt-dlp \
fzf \
entr \
git-delta

if command -v nix-env; then
  nix-env -iA nixpkgs.fzf nixpkgs.du-dust nixpkgs.sumneko-lua-language-server
else
  echo "Skipping nix packages, Nix not installed"
fi
