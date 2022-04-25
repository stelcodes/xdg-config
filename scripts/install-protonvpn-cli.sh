#!/usr/bin/env bash
# https://protonvpn.com/support/linux-vpn-tool/#fedora
set -e
OUTDIR="/tmp/protonvpn-cli-rpm-$(date +%s)"
mkdir $OUTDIR
wget --show-progress \
  --directory-prefix=$OUTDIR \
  https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm
sudo dnf install $OUTDIR/*.rpm
sudo dnf update
sudo dnf install protonvpn-cli
