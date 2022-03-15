#!/usr/bin/env bash

if ! command -v trash &> /dev/null; then echo "This script requires the package trash-cli"; exit 1; fi

mkdir `xdg-user-dir DESKTOP`
mkdir `xdg-user-dir DOCUMENTS`
mkdir `xdg-user-dir DOWNLOADS`
mkdir `xdg-user-dir MUSIC`
mkdir `xdg-user-dir PICTURES`
mkdir `xdg-user-dir PUBLICSHARE`
mkdir `xdg-user-dir TEMPLATES`
mkdir `xdg-user-dir VIDEOS`

trash $HOME/Desktop
trash $HOME/Documents
trash $HOME/Downloads
trash $HOME/Music
trash $HOME/Pictures
trash $HOME/Public
trash $HOME/Templates
trash $HOME/Videos
