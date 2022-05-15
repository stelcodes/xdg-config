#!/usr/bin/env bash
set -e

if test $(command -v getenforce) && test $(getenforce | grep -i 'enforcing'); then
  echo "SELinux is enabled. Refusing to install Nix"
  exit 1
fi

sh <(curl -L https://nixos.org/nix/install) --daemon
