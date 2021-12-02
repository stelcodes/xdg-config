#!/usr/bin/env bash

# Tmux Package Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Prefix-I to install, Prefix-U to upgrade, Prefix-alt-u to uninstall

# Vim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Nix (multi-user mode)
# sh <(curl -L https://nixos.org/nix/install) --daemon
