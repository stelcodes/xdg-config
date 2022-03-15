# Fedora Media Writer
`dnf install mediawriter`
Requires a polkit authentication agent: https://wiki.archlinux.org/title/Polkit
On Gnome/KDE and every other desktop environment there is one built in.
On sway/i3 you have to start one yourself.
Most are packaged as a library. Only a few are packaged as an executable.
Out of those `lxpolkit` seems to be the best option.
`dnf install lxpolkit`
Run `lxpolkit` and then start `mediawriter`

# Manual (kinda dangerous) method
`sudo dd if=/home/stel/downloads/ubuntu-20.04.4-desktop-amd64.iso of=/dev/sdb bs=8M status=progress oflag=direct`
