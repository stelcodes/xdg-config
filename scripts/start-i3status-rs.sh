#!/usr/bin/env bash

OWM_KEY_FILE="$HOME/sync/secrets/openweathermap-api-key"

if [[ -f $OWM_KEY_FILE ]]; then
  export OPENWEATHERMAP_API_KEY $(cat $OWM_KEY_FILE)
fi

i3status-rs 2>> /tmp/i3status-rs-errors.log
