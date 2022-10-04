# Guides
https://guides.frame.work/Guide/Fedora+36+Installation+on+the+Framework+Laptop/108

# i3 Scaling
```
echo "Xft.dpi: 180" > ~/.Xresources
```

# Virtual Terminal Font
```
# Default virtual terminal font is eurlatgr, way too small
sudo echo 'FONT="latarcyrheb-sun32"' > /etc/vconsole.conf
nvim /etc/default/grub
# Append vconsole.font=latarcyrheb-sun32 (with a space before it!) to the line GRUB_CMDLINE_LINUX=
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

# Issues
https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1/23171/27
https://community.frame.work/t/12th-gen-not-sending-xf86monbrightnessup-down/20605/13

## Sway doesn't work out of the box
https://github.com/swaywm/sway/issues/7022

Must set `WLR_DRM_NO_MODIFIERS=1` env var.

This should be fixed now that I've added a `~/.config/environment.d/sway.conf` file with the sway-specific env vars.
