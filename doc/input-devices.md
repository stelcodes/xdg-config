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
