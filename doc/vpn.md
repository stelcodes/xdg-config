# Connecting to VPN via OpenVPN config and NetworkManager
https://computingforgeeks.com/how-to-use-nmcli-to-connect-to-openvpn-server-on-linux/
```
sudo apt install network-manager-openvpn network-manager-pptp
sudo nmcli connection import type openvpn file myopenvp.ovpn
```
