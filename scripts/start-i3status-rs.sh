#!/usr/bin/env bash

export OPENWEATHERMAP_API_KEY=`cat $HOME/sync/secrets/openweathermap-api-key`
export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

i3status-rs 2>> /tmp/i3status-rs-errors.log
