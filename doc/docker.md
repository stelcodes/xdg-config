# Install
## Debian
https://docs.docker.com/engine/install/debian/#install-using-the-repository
https://docs.docker.com/engine/install/
https://docs.docker.com/engine/install/linux-postinstall/
## Fedora
https://developer.fedoraproject.org/tools/docker/docker-installation.html
- Make sure dnf plugins are enabled:
```
sudo dnf install dnf-plugins-core
```
- Add docker ce repo to dnf:
```
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```
- Install docker engine, the cli interface, and the containerd OCI runtime
```
sudo dnf install docker-ce docker-ce-cli containerd.io
```
- Start the docker service and optionally start it at boot
```
sudo systemctl start docker
sudo systemctl enable docker
```
- Test installation works
```
sudo docker run hello-world
```

# Basics
https://developer.fedoraproject.org/tools/docker/docker-usage.html
```
sudo docker run -it fedora bash
```
