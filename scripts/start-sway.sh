#!/usr/bin/env bash

export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1

exec sway | tee /tmp/sway.log
