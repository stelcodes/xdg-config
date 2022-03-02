# Syncthing

`dnf install syncthing`

Make sure to change firewall rules:

```
firewall-cmd --add-service=syncthing --permanent
firewall-cmd --reload
```
Add systemd user service file in .config. Reference files are located [here](https://github.com/syncthing/syncthing/tree/main/etc/linux-systemd).
```
systemctl --user enable syncthing
systemctl --user start syncthing
```

Then open up the web GUI at https://127.0.0.1:8384

Delete the Default folder

Connect to the other nodes by adding remote device. The unique identifier should pop up if it's on your local network. Add the remote devices.

From the other nodes, share the default folder.

From the new node, accept the folder and store at `~/sync`.

Then connect to the new computer from previous syncthing nodes,
and share the previous folders with new node.
