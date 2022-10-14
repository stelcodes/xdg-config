#!/usr/bin/env bash

export WLR_DRM_NO_MODIFIERS=1
export XDG_CURRENT_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1
export WAYLAND_DISPLAY=1
export QT_QPA_PLATFORM=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export GTK_THEME=Dracula
export QT_QPA_PLATFORMTHEME=qt5ct
export BEMENU_OPTS="--tb '#6272a4' --tf '#f8f8f2' --fb '#282a36' --ff '#f8f8f2' --nb '#282a36' --nf '#6272a4' --hb '#44475a' --hf '#50fa7b' --sb '#44475a' --sf '#50fa7b' --scb '#282a36' --scf '#ff79c6'"

exec sway
