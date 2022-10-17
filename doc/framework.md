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

# Extending battery life
https://www.jameskupke.com/posts/using-framework-with-fedora
Also https://community.frame.work/t/linux-deep-sleep/2491/60

## Enable S3 deep sleep
```
sudo grubby --update-kernel=ALL --args=mem_sleep_default=deep
```

## tlp
https://linrunner.de/tlp/usage/index.html
```
sudo dnf install tlp
sudo cp /home/stel/.config/files/10-tlp.conf /etc/tlp.d/
sudo systemctl enable --now tlp
systemctl mask power-profiles-daemon.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
```

## Intel audio card powersave
https://wiki.archlinux.org/title/Power_management#Audio
```
sudo cp /home/stel/.config/files/10-modprobe-intel-audio-powersave.conf /etc/modprobe.d/
```

## Hibernation
https://fedoramagazine.org/hibernation-in-fedora-36-workstation/
- Must disable secure boot first in UEFI BIOS menu
```
sudo ~/.config/scripts/enable-fedora-36-hibernation.sh
```

## Hibernate on low battery
```
sudo cp ~/.config/files/10-lowbat.rules /etc/udev/rules.d/
```

# Issues
https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1/23171/27
https://community.frame.work/t/12th-gen-not-sending-xf86monbrightnessup-down/20605/13

## Sway doesn't work out of the box
https://github.com/swaywm/sway/issues/7022

Must set `WLR_DRM_NO_MODIFIERS=1` env var.

This should be fixed now that I've added a `~/.config/environment.d/sway.conf` file with the sway-specific env vars.
