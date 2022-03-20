#!/usr/bin/env bash
sudo setenforce 0
sh <(curl -L https://nixos.org/nix/install) --daemon
sudo setenforce 1
