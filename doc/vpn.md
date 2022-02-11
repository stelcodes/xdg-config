# Connecting to VPN via OpenVPN config and NetworkManager
https://computingforgeeks.com/how-to-use-nmcli-to-connect-to-openvpn-server-on-linux/
```
sudo apt install network-manager-openvpn network-manager-pptp
sudo nmcli connection import type openvpn file myopenvp.ovpn
```
# Proton VPN
Install protonvpn-cli from the instructions in this repo: https://github.com/ProtonVPN/linux-cli
It's way better than version from dnf
Then install these packages:
```
dnf install openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome gnome-keyring(essential)
```
Then login:
```
protonvpn-cli login
```
Before you connect you must make sure nm-applet is running:
```
nm-applet &
```

