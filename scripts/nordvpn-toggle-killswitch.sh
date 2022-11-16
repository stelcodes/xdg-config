#!/usr/bin/env bash

fail() {
  notify-send --app-name=nordvpn --urgency=critical "NordVPN" "Killswitch changes were unsuccessful"
  exit 1
}

enable_killswitch() {
  nordvpn set firewall enable \
    && nordvpn set killswitch enable \
    && notify-send --app-name=nordvpn --urgency=normal "NordVPN" "Killswitch enabled";
}

disable_killswitch() {
  nordvpn set killswitch disable \
    && nordvpn set firewall disable \
    && notify-send --app-name=nordvpn --urgency=normal "NordVPN" "Killswitch disabled";
}

if [[ $(nordvpn settings | grep 'Kill Switch: enabled') ]]; then
  disable_killswitch || fail
else
  enable_killswitch || fail
fi
