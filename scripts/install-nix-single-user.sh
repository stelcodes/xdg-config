#!/usr/bin/env bash

set -ex

sh <(curl -L https://nixos.org/nix/install) --no-daemon

# There's a bug in the ~/.nix-profile/etc/profile.d/nix.fish file where the MANPATH shouldn't
# be set if not already set. This causes the default /opt/local/share/man to not be in MANPATH
# making all dnf man pages unreadble. Erasing the MANPATH env var fixes this.
NIX_FISH=~/.config/fish/conf.d/nix.fish
if [[ -f $NIX_FISH && -z $(grep "MANPATH" $NIX_FISH) ]]; then
  echo "set --erase MANPATH" >> $NIX_FISH
fi
