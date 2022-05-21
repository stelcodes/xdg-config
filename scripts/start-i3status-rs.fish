#!/usr/bin/env fish

set -x OPENWEATHERMAP_API_KEY (cat $HOME/sync/secrets/openweathermap-api-key)

i3status-rs 2>> /tmp/i3status-rs-errors.log
