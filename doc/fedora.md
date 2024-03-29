# Fresh Workstation Install Setup
https://www.youtube.com/watch?v=RrRpXs2pkzg

- Change hostname and keymap
```
sudo hostnamectl set-hostname "New_Custom_Name"
localectl set-x11-keymap "" "" "" caps:escape
```

- Update dnf
```
sudo dnf update
```

- Install my packages, themes, and fonts
```
# For all installations
~/.config/scripts/update-dnf-settings.sh
~/.config/scripts/install-fedora-core-packages.sh

# For workstations only
~/.config/scripts/replace-xdg-user-dirs.sh
~/.config/scripts/install-nix-single-user.sh
~/.config/scripts/install-fedora-workstation-packages.sh
~/.config/scripts/install-themes.sh
~/.config/scripts/install-fonts.sh
```

-------------------------------------------------------------------------------

# GDM Sessions
## Turn on autologin at boot
`/etc/gdm/custom.conf`:
```
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=stel
```

## sway
### Environment variables
By default sway is run as a systemd service. The service runs a `sway.desktop` file installed by the official package. These files get overwritten when a new version is installed so the best way to add environment variables to sway by using a command like this in the sway config:
```
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway WLR_DRM_NO_MODIFIERS=1 MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland _JAVA_AWT_WM_NONREPARENTING=1 GTK_THEME=Dracula QT_QPA_PLATFORMTHEME=qt5ct
```

# dnf
https://dnf.readthedocs.io/en/latest/conf_ref.html

## Update packages
`dnf update`

## /etc/dnf/dnf.conf
```
# Added by stel
fastestmirror=True
max_parallel_downloads=10
keepcache=True
# Only update kernel when --disableexcludes flag is present
excludepkgs=kernel*
```
Run `sudo dnf upgrade 'kernel*' --disableexcludes main` to upgrade kernel

## Downgrade a package
`dnf --showduplicates list <package>`
`dnf downgrade package-name[-version]`

## Turn off command suggestions
`dnf erase PackageKit-command-not-found`

# Firewall
Lock down the firewall:
```
firewall-cmd --remove-port 1025-65535/udp --remove-port 1025-65535/tcp --permanent
firewall-cmd --reload
```

# Samba Share
https://docs.fedoraproject.org/en-US/quick-docs/samba/
```
dnf install samba
systemctl enable smb --now
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
```
Add stel user and set password:
```
smbpasswd -a stel
```
Edit samba shares at `/etc/samba/smb.conf` (man 5 smb.conf):
```
[library]
	comment = My Library
	path = /mnt/library
	writable = no
	browseable = yes
	guest ok = no
	valid users = stel
```
Restart Samba for the changes to take effect:
```
sudo systemctl restart smb
```
Debug:
```
tail -f /var/log/samba/log.smbd
```
Status:
```
smbstatus
```

# Setting up Fedora Server on a Cloud VM
I'm using Hetzner cloud currently.
- Add ssh key to hetzner UI and add when creating server
- Add name of machine to local `/etc/hosts` for convienence
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
5.161.118.153 suicune
```
- log in as root `ssh root@<hostname>`

# neovim
```
dnf install neovim
mkdir -p ~/.config/nvim
echo 'vim.cmd [[ tnoremap <Esc> <C-\><C-n> ]]' > ~/.config/nvim/init.lua
```

# Add normal user
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
mkdir ~/bin
mkdir ~/.local/bin
```

# sshd
```
nvim /etc/ssh/sshd_config
```
Make sure these are set:
```
PasswordAuthentication no
PermitEmptyPasswords no
```

# firewalld
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

# Date and Time
https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/basic-system-configuration/Configuring_the_Date_and_Time/
https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/servers/Configuring_NTP_Using_the_chrony_Suite/

On fedora server at least, you should install an NTP server. Use chronyd:
```
dnf install chrony
systemctl enable chronyd.service
systemctl start chronyd.service
# I'm not sure what this preinstalled service does. I think it waits when booting until chronyd starts
systemctl enable chrony-wait.service
systemctl start chrony-wait.service
```
Not sure how fedora workstation handles time by deafult

# caddy
```
dnf install caddy
ls /usr/lib/systemd/system/caddy*
systemctl enable caddy
systemctl start caddy
nvim /etc/caddy/Caddyfile
```
The systemd service uses a new user called `caddy`.
Remember, home dirs cannot be read by outside users so caddy can't serve from `/home/stel/<some-dir>`
```
mkdir /var/www
chown stel:stel /var/www
```

# postgres
If `dnf info postgresql` is not new enough version:
From https://www.postgresql.org/download/linux/redhat/
```
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-35-x86_64/pgdg-fedora-repo-latest.noarch.rpm
sudo dnf install -y postgresql14-server
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14
```
Else:
https://docs.fedoraproject.org/en-US/quick-docs/postgresql/
```
sudo dnf install postgresql-server postgresql-contrib
sudo systemctl enable postgresql
sudo postgresql-setup --initdb --unit postgresql
sudo systemctl start postgresql
```
Set a `postgres` user password and create user `stel` and set password
```
sudo -u postgres psql
postgres=# \password postgres
postgres=# CREATE ROLE stel SUPERUSER LOGIN;
postgres=# \password stel
```

# Create app user
```
sudo useradd functional_news_app --create-home
sudo passwd functional_news_app
sudo chown -R functional_news_app:stel /home/functional_news_app
sudo chmod -R g=u /home/functional_news_app
cd /home/functional_news_app
umask g+w
```
If you mess up you can just delete the user and their directory:
```
sudo userdel --remove --selinux-user somebaduser
```

# Postgres
```
psql postgres
postgres=# CREATE ROLE functional_news_app LOGIN;
postgres=# \password functional_news_app;
postgres=# CREATE DATABASE functional_news OWNER stel;
postgres=# GRANT ALL ON DATABASE functional_news TO functional_news_app;
```
Now you should be able to login to psql with the new app user via the default `host`: `ident` permissions:
```
sudo -u functional_news_app psql -U functional_news_app functional_news
```

# Clojure
To get `jar` command install devel versions of openjdk:
```
sudo dnf install java-11-openjdk-devel
```

