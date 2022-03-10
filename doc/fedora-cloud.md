# Setting up Fedora 35 on a Cloud VM
I'm using Hetzner cloud currently.
- Add ssh key to hetzner UI and add when creating server
- log in as root `ssh root@<ip>`

## neovim
```
dnf install neovim
mkdir -p ~/.config/nvim
echo 'vim.cmd [[ tnoremap <Esc> <C-\><C-n> ]]' > ~/.config/nvim/init.lua
```

## Add normal user
- Add normal user, set password, add ssh public key to their home dir
```
useradd stel --create-home --shell /usr/bin/bash --groups wheel --user-group
passwd stel
mkdir /home/stel/.ssh
nvim /home/stel/.ssh/authorized_keys
# Add public key
```
As the normal user:
```
git clone https://github.com/stelcodes/xdg-config ~/.config
~/.config/scripts/fedora-server-bootstrap.sh
command -v fish
sudo lchsh stel
```

## sshd
```
nvim /etc/ssh/sshd_config
```
Make sure these are set:
```
PasswordAuthentication no
PermitEmptyPasswords no
```

## firewalld
https://docs.fedoraproject.org/en-US/quick-docs/firewalld/
```
dnf install firewalld
systemctl start firewalld
firewall-cmd --list-all
```
https://firewalld.org/documentation/man-pages/firewall-cmd.html
Firewalld is dynamic meaning it can be changed on the fly without restarting and affecting incoming traffic.
Any changes will not persist on restart unless explicitly asked for:
```
firewall-cmd --permanent ...
# or save all configuration
firewall-cmd --runtime-to-permanent
```
Adding a port or service:
https://firewalld.org/documentation/howto/open-a-port-or-service.html
```
firewall-cmd --get-services
firewall-cmd --add-service=http --add-service=https
```

## caddy
```
dnf install caddy
ls /usr/lib/systemd/system/caddy*
systemctl enable caddy
systemctl start caddy
nvim /etc/caddy/Caddyfile
```
The systemd service uses a new user called `caddy`.
Remember, home dirs cannot be read by outside users so caddy can't serve from `/home/stel/<some-dir>`

## postgres
If `dnf info postgresql` is not new enough version:
From https://www.postgresql.org/download/linux/redhat/
```
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-35-x86_64/pgdg-fedora-repo-latest.noarch.rpm
sudo dnf install -y postgresql14-server
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14
```
