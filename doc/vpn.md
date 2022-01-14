# Connecting to VPN via OpenVPN config and NetworkManager
https://computingforgeeks.com/how-to-use-nmcli-to-connect-to-openvpn-server-on-linux/
```
sudo apt install network-manager-openvpn network-manager-pptp
sudo nmcli connection import type openvpn file myopenvp.ovpn
```

Turn off ipv6 for connections that need to use protonvpn because it doesn't support ipv6 tunneling atm
sudo nmcli connection modify id slughug ipv6.method disabled
