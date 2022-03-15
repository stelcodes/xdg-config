# Keyboards
## Make Caps Lock into another Escape
For Fedora 35 and tty
```
sudo loadkeys <<< 'keycode 58 = Escape'
```
For Fedora 35 and X11
```
dnf install setxkbmap
setxkbmap -option caps:escape
```
Sway handles this in the config file

## Disable Power Button
On systemd machines, logind handles this.
In /etc/systemd/logind.conf
```
HandlePowerKey=ignore
```
Must restart logind afterwards, easiest way is to just reboot.

## Swap alt and super keys on a Mac keyboard
https://unix.stackexchange.com/questions/86933/swap-alt-and-super
```
echo 1 | tee /sys/module/hid_apple/parameters/swap_opt_cmd
# or use altwin:swap_alt_win xkbmap option
```

# Trackpads
## For Fedora 35 and X11
https://gist.github.com/111A5AB1/d353af199fd523d33f222850834f9cc5
```
dnf install xinput
xinput --list
```
My 2013 MacBook Air trackpad name is listed as `bcm5974	id=11	[slave  pointer  (2)]`
```
xinput --list-props 11
```
Option we'd like to set is `libinput Natural Scrolling Enabled (318):	0`
```
xinput --set-prop 11 318 1
```

# Webcam
## For Fedora 35
facetimehd camera needs manually installed driver:
https://copr.fedorainfracloud.org/coprs/frgt10/facetimehd-dkms/
https://github.com/patjak/facetimehd/wiki/Get-Started#firmware-extraction
- extract the firmware
- install it
- add sensor calibration files (see ~/backups/fthd.tar.gz)

# Wifi
## For Fedora 35
My 2013 Macbook has a Broadcom wifi chip that doesn't play nice with linux
lspci output: `Network controller: Broadcom Inc. and subsidiaries BCM4360 802.11ac Wireless Network Adapter`
First, optionally update the kernel because we're about to be installing a kernel mod:
```
dnf update
dnf install kernel --best
grubby --default-kernel
systemctl reboot
```
Make sure RPM Fusion repos are added because that's where the `broadcom-wl` package is.
Then install kernel mod:
```
dnf install broadcom-wl akmods
cat /usr/share/doc/broadcom-wl/fedora.readme | less
akmods --force --kernel `uname -r` --akmod wl
# Might have to reboot a couple times
systemctl reboot
```
https://www.reddit.com/r/Fedora/comments/emb0de/having_some_difficulty_getting_broadcom_bcm4360/
Might have to reload the driver every now and then before connecting to access points:
```
modprobe -r wl
modprobe -i wl
```
