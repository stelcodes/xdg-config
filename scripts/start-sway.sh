#!/usr/bin/env bash

export WLR_DRM_NO_MODIFIERS=1
export XDG_CURRENT_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1
export WAYLAND_DISPLAY=1
export QT_QPA_PLATFORM=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
# export GTK_THEME=Dracula
export QT_QPA_PLATFORMTHEME=qt5ct

sway
