#!/usr/bin/env bash

if ! command -v trash &> /dev/null; then echo "This script requires the package trash-cli"; exit 1; fi

mkdir --verbose `xdg-user-dir DESKTOP`
mkdir --verbose `xdg-user-dir DOCUMENTS`
mkdir --verbose `xdg-user-dir DOWNLOADS`
mkdir --verbose `xdg-user-dir MUSIC`
mkdir --verbose `xdg-user-dir PICTURES`
mkdir --verbose `xdg-user-dir PUBLICSHARE`
mkdir --verbose `xdg-user-dir TEMPLATES`
mkdir --verbose `xdg-user-dir VIDEOS`

trash --verbose $HOME/Desktop
trash --verbose $HOME/Documents
trash --verbose $HOME/Downloads
trash --verbose $HOME/Music
trash --verbose $HOME/Pictures
trash --verbose $HOME/Public
trash --verbose $HOME/Templates
trash --verbose $HOME/Videos
