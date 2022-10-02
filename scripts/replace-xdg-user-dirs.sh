#!/usr/bin/env bash

set -e

DESKTOP=$(xdg-user-dir DESKTOP)
STD_DESKTOP=$HOME/Desktop
if test -d $STD_DESKTOP && test ! -d $DESKTOP; then
  echo "Moving $STD_DESKTOP to $DESKTOP"
  mv -n $STD_DESKTOP $DESKTOP
elif test ! -d $DESKTOP; then
  echo "Creating $DESKTOP"
  mkdir $DESKTOP
else
  echo "Skipping $DESKTOP"
fi

DOCUMENTS=$(xdg-user-dir DOCUMENTS)
STD_DOCUMENTS=$HOME/Documents
if test -d $STD_DOCUMENTS && test ! -d $DOCUMENTS; then
  echo "Moving $STD_DOCUMENTS to $DOCUMENTS"
  mv -n $STD_DOCUMENTS $DOCUMENTS
elif test ! -d $DOCUMENTS; then
  echo "Creating $DOCUMENTS"
  mkdir $DOCUMENTS
else
  echo "Skipping $DOCUMENTS"
fi


DOWNLOAD=$(xdg-user-dir DOWNLOAD)
STD_DOWNLOAD=$HOME/Downloads
if test -d $STD_DOWNLOAD && test ! -d $DOWNLOAD; then
  echo "Moving $STD_DOWNLOAD to $DOWNLOAD"
  mv -n $STD_DOWNLOAD $DOWNLOAD
elif test ! -d $DOWNLOAD; then
  echo "Creating $DOWNLOAD"
  mkdir $DOWNLOAD
else
  echo "Skipping $DOWNLOAD"
fi

MUSIC=$(xdg-user-dir MUSIC)
STD_MUSIC=$HOME/Music
if test -d $STD_MUSIC && test ! -d $MUSIC; then
  echo "Moving $STD_MUSIC to $MUSIC"
  mv -n $STD_MUSIC $MUSIC
elif test ! -d $MUSIC; then
  echo "Creating $MUSIC"
  mkdir $MUSIC
else
  echo "Skipping $MUSIC"
fi


PICTURES=$(xdg-user-dir PICTURES)
STD_PICTURES=$HOME/Pictures
if test -d $STD_PICTURES && test ! -d $PICTURES; then
  echo "Moving $STD_PICTURES to $PICTURES"
  mv -n $STD_PICTURES $PICTURES
elif test ! -d $PICTURES; then
  echo "Creating $PICTURES"
  mkdir $PICTURES
else
  echo "Skipping $PICTURES"
fi

PUBLICSHARE=$(xdg-user-dir PUBLICSHARE)
STD_PUBLICSHARE=$HOME/Public
if test -d $STD_PUBLICSHARE && test ! -d $PUBLICSHARE; then
  echo "Moving $STD_PUBLICSHARE to $PUBLICSHARE"
  mv -n $STD_PUBLICSHARE $PUBLICSHARE
elif test ! -d $PUBLICSHARE; then
  echo "Creating $PUBLICSHARE"
  mkdir $PUBLICSHARE
else
  echo "Skipping $PUBLICSHARE"
fi

TEMPLATES=$(xdg-user-dir TEMPLATES)
STD_TEMPLATES=$HOME/Templates
if test -d $STD_TEMPLATES && test ! -d $TEMPLATES; then
  echo "Moving $STD_TEMPLATES to $TEMPLATES"
  mv -n $STD_TEMPLATES $TEMPLATES
elif test ! -d $TEMPLATES; then
  echo "Creating $TEMPLATES"
  mkdir $TEMPLATES
else
  echo "Skipping $TEMPLATES"
fi

VIDEOS=$(xdg-user-dir VIDEOS)
STD_VIDEOS=$HOME/Videos
if test -d $STD_VIDEOS && test ! -d $VIDEOS; then
  echo "Moving $STD_VIDEOS to $VIDEOS"
  mv -n $STD_VIDEOS $VIDEOS
elif test ! -d $VIDEOS; then
  echo "Creating $VIDEOS"
  mkdir $VIDEOS
else
  echo "Skipping $VIDEOS"
fi
