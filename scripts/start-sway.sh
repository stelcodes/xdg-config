export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
# Firefox and tor don't work well under wayland, but firefox needs this to screenshare under sway
export MOZ_ENABLE_WAYLAND=1
exec sway
