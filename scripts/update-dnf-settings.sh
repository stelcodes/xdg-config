#!/usr/bin/env bash

sudo cat << EOF | sudo tee /etc/dnf/dnf.conf
# see \`man dnf.conf\` for defaults and possible options

[main]
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
# Added by stel
fastestmirror=True
max_parallel_downloads=5
keepcache=True
# Only update kernel when --disableexcludes flag is present
excludepkgs=kernel*
EOF
