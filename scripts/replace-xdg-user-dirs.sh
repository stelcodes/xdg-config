#!/usr/bin/env bash

set -e

DESKTOP=$(xdg-user-dir DESKTOP)
STD_DESKTOP=$HOME/Desktop
if [[ -d $STD_DESKTOP && ! -d $DESKTOP ]]; then
  echo "Moving $STD_DESKTOP to $DESKTOP"
  mv -n $STD_DESKTOP $DESKTOP
elif [[ ! -d $DESKTOP ]]; then
  echo "Creating $DESKTOP"
  mkdir $DESKTOP
else
  echo "Skipping $DESKTOP"
fi

DOCUMENTS=$(xdg-user-dir DOCUMENTS)
STD_DOCUMENTS=$HOME/Documents
if [[ -d $STD_DOCUMENTS && ! -d $DOCUMENTS ]]; then
  echo "Moving $STD_DOCUMENTS to $DOCUMENTS"
  mv -n $STD_DOCUMENTS $DOCUMENTS
elif [[ ! -d $DOCUMENTS ]]; then
  echo "Creating $DOCUMENTS"
  mkdir $DOCUMENTS
else
  echo "Skipping $DOCUMENTS"
fi


DOWNLOAD=$(xdg-user-dir DOWNLOAD)
STD_DOWNLOAD=$HOME/Downloads
if [[ -d $STD_DOWNLOAD && ! -d $DOWNLOAD ]]; then
  echo "Moving $STD_DOWNLOAD to $DOWNLOAD"
  mv -n $STD_DOWNLOAD $DOWNLOAD
elif [[ ! -d $DOWNLOAD ]]; then
  echo "Creating $DOWNLOAD"
  mkdir $DOWNLOAD
else
  echo "Skipping $DOWNLOAD"
fi

MUSIC=$(xdg-user-dir MUSIC)
STD_MUSIC=$HOME/Music
if [[ -d $STD_MUSIC && ! -d $MUSIC ]]; then
  echo "Moving $STD_MUSIC to $MUSIC"
  mv -n $STD_MUSIC $MUSIC
elif [[ ! -d $MUSIC ]]; then
  echo "Creating $MUSIC"
  mkdir $MUSIC
else
  echo "Skipping $MUSIC"
fi


PICTURES=$(xdg-user-dir PICTURES)
STD_PICTURES=$HOME/Pictures
if [[ -d $STD_PICTURES && ! -d $PICTURES ]]; then
  echo "Moving $STD_PICTURES to $PICTURES"
  mv -n $STD_PICTURES $PICTURES
elif [[ ! -d $PICTURES ]]; then
  echo "Creating $PICTURES"
  mkdir $PICTURES
else
  echo "Skipping $PICTURES"
fi

mkdir "$PICTURES/screenshots" &> /dev/null || :

PUBLICSHARE=$(xdg-user-dir PUBLICSHARE)
STD_PUBLICSHARE=$HOME/Public
if [[ -d $STD_PUBLICSHARE && ! -d $PUBLICSHARE ]]; then
  echo "Moving $STD_PUBLICSHARE to $PUBLICSHARE"
  mv -n $STD_PUBLICSHARE $PUBLICSHARE
elif [[ ! -d $PUBLICSHARE ]]; then
  echo "Creating $PUBLICSHARE"
  mkdir $PUBLICSHARE
else
  echo "Skipping $PUBLICSHARE"
fi

TEMPLATES=$(xdg-user-dir TEMPLATES)
STD_TEMPLATES=$HOME/Templates
if [[ -d $STD_TEMPLATES && ! -d $TEMPLATES ]]; then
  echo "Moving $STD_TEMPLATES to $TEMPLATES"
  mv -n $STD_TEMPLATES $TEMPLATES
elif [[ ! -d $TEMPLATES ]]; then
  echo "Creating $TEMPLATES"
  mkdir $TEMPLATES
else
  echo "Skipping $TEMPLATES"
fi

VIDEOS=$(xdg-user-dir VIDEOS)
STD_VIDEOS=$HOME/Videos
if [[ -d $STD_VIDEOS && ! -d $VIDEOS ]]; then
  echo "Moving $STD_VIDEOS to $VIDEOS"
  mv -n $STD_VIDEOS $VIDEOS
elif [[ ! -d $VIDEOS ]]; then
  echo "Creating $VIDEOS"
  mkdir $VIDEOS
else
  echo "Skipping $VIDEOS"
fi
