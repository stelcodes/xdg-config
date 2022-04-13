https://www.atlantic.net/dedicated-server-hosting/how-to-install-and-use-podman-on-ubuntu-20-04/
# Random
- Images are the compressed filesystem made up of layers
- Containers are the container environments that are created when you run the images
# Install
```
sudo apt -t bookworm install podman
sudo systemctl start podman
sudo systemctl start podman.socket
sudo curl -H "Content-Type: application/json" --unix-socket /run/podman/podman.sock http://localhost/_ping
```

## Docker compatibility
The package `podman-docker` provides `/usr/bin/docker` which emulates docker's CLI with podman
```
sudo apt -t bookworm install podman-docker
```
# Add registries
/etc/containers/registries.conf
```
[registries.search]
registries = ['docker.io', 'registry.fedoraproject.org', 'registry.access.redhat.com']
```
```
podman search nginx
podman pull nginx
podman images
```
```
podman run --detach --interactive --tty nginx
podman ps
podman stop <image-id>
podman start <image-id>
```

# Run stuff
`docker run -e 'POSTGRES_PASSWORD=password POSTGRES_HOST_AUTH_METHOD=trust' postgres:14`

# See Running Containers
`docker ps`
