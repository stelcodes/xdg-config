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
```

## Intel audio card powersave
https://wiki.archlinux.org/title/Power_management#Audio
```
sudo cp /home/stel/.config/files/10-modprobe-intel-audio-powersave.conf /etc/modprobe.d/
```

## Hibernation
https://fedoramagazine.org/hibernation-in-fedora-36-workstation/
- Must disable secure boot first in UEFI BIOS menu

### Make swap btrfs subvolume
`SWAPFILE_SIZE`: RAM size + 3 x zRAM size, check with `swapon` (ex: `64G`)
```
btrfs subvolume create /swap
touch /swap/swapfile
chattr +C /swap/swapfile
fallocate --length <SWAPFILE_SIZE> /swap/swapfile
chmod 600 /swap/swapfile
mkswap /swap/swapfile
```

### Configure dracut
```
cat <<-EOF | sudo tee /etc/dracut.conf.d/resume.conf
add_dracutmodules+=" resume "
EOF
dracut -f
```

### Add kernel params
```
# Find UUID of swapfile
findmnt -no UUID -T /swap/swapfile

# Find physical offset of swapfile
cd /tmp
cp /home/stel/.config/files/btrfs_map_physical.c .
gcc -O2 -o btrfs_map_physical btrfs_map_physical.c
./btrfs_map_physical /swap/swapfile | sed -n 2p | cut -f9

# Find pagesize
getconf PAGESIZE

# Update kernel params
grubby --args="resume=UUID=<UUID> resume_offset=<PHYSICAL_OFFSET_DIVIDED_BY_PAGESIZE>" --update-kernel=ALL
```

### Create systemd units
```
cat <<-EOF | sudo tee /etc/systemd/system/hibernate-preparation.service
[Unit]
Description=Enable swap file and disable zram before hibernate
Before=systemd-hibernate.service

[Service]
User=root
Type=oneshot
ExecStart=/bin/bash -c "/usr/sbin/swapon /swap/swapfile && /usr/sbin/swapoff /dev/zram0"

[Install]
WantedBy=systemd-hibernate.service
EOF

systemctl enable hibernate-preparation.service

cat <<-EOF | sudo tee /etc/systemd/system/hibernate-resume.service
[Unit]
Description=Disable swap after resuming from hibernation
After=hibernate.target

[Service]
User=root
Type=oneshot
ExecStart=/usr/sbin/swapoff /swap/swapfile

[Install]
WantedBy=hibernate.target
EOF

systemctl enable hibernate-resume.service
```

### Disable systemd memory checks
```
mkdir -p /etc/systemd/system/systemd-logind.service.d/

cat <<-EOF | sudo tee /etc/systemd/system/systemd-logind.service.d/override.conf
[Service]
Environment=SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK=1
EOF

mkdir -p /etc/systemd/system/systemd-hibernate.service.d/

cat <<-EOF | sudo tee /etc/systemd/system/systemd-hibernate.service.d/override.conf
[Service]
Environment=SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK=1
EOF
```
At this point, reboot.

### Configure SELinux
The output of `audit2allow -b` should look like:
```
#============= systemd_sleep_t ==============
allow systemd_sleep_t unlabeled_t:dir search;
```
Create and install module:
```
cd /tmp
audit2allow -b -M systemd_sleep
semodule -i systemd_sleep.pp
```

### Ensure only ZRAM is enabled during normal use
Running `swapon` should only show ZRAM:
```
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition   8G   0B  100
```

### Enable hibernation triggers
```
mkdir -p /etc/systemd/logind.conf.d
cp /home/stel/.config/files/10-laptop-logind.conf /etc/systemd/logind.conf.d

mkdir -p /etc/systemd/sleep.conf.d
cp /home/stel/.config/files/10-laptop-sleep.conf /etc/systemd/sleep.conf.d
```

# Issues
https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1/23171/27
https://community.frame.work/t/12th-gen-not-sending-xf86monbrightnessup-down/20605/13

## Sway doesn't work out of the box
https://github.com/swaywm/sway/issues/7022

Must set `WLR_DRM_NO_MODIFIERS=1` env var.

This should be fixed now that I've added a `~/.config/environment.d/sway.conf` file with the sway-specific env vars.
