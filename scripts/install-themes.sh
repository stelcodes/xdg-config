#!/usr/bin/env bash
set -e

TMP_DIR=/tmp/dracula-gtk-theme
THEME_DIR=~/.themes/Dracula
ICON_DIR=~/.icons/Dracula
SKIP_THEME=0
SKIP_ICONS=0

###############################################################################
# Install Dracula Themes

if test -e $TMP_DIR; then
  trash $TMP_DIR
fi

mkdir -p ~/.themes
if test -e $THEME_DIR; then
  echo "$THEME_DIR already exists"
  read -p "Replace $THEME_DIR? [y/N]: " REPLACE_THEME_DIR
  if test "y" = $REPLACE_THEME_DIR; then
    trash $THEME_DIR
  else
    SKIP_THEME=1
  fi
fi

if test $SKIP_THEME -eq 0; then
  echo "Downloading Dracula theme pack"
  wget --no-verbose --show-progress --directory-prefix=$TMP_DIR https://github.com/dracula/gtk/archive/master.zip
  echo "Unzipping Dracula theme pack"
  unzip $TMP_DIR/master.zip -d $TMP_DIR > /dev/null
  echo "Installing Dracula theme pack"
  mv $TMP_DIR/gtk-master $THEME_DIR
  gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
  gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
else
  echo "Skipping theme installation"
fi

###############################################################################
# Install Dracula Icons

if test -e $TMP_DIR; then
  trash $TMP_DIR
fi

mkdir -p ~/.icons
if test -e $ICON_DIR; then
  echo "$ICON_DIR already exists"
  read -p "Replace $ICON_DIR? [y/N]: " REPLACE_ICON_DIR
  if test "y" = $REPLACE_ICON_DIR; then
    trash $ICON_DIR
  else
    SKIP_ICONS=1
  fi
fi

if test $SKIP_ICONS -eq 0; then
  echo "Downloading Dracula icon pack"
  wget --no-verbose --show-progress --directory-prefix=$TMP_DIR https://github.com/dracula/gtk/files/5214870/Dracula.zip
  echo "Unzipping Dracula icon pack"
  unzip $TMP_DIR/Dracula.zip -d $TMP_DIR > /dev/null
  echo "Installing Dracula icon pack"
  mv $TMP_DIR/Dracula $ICON_DIR
  gsettings set org.gnome.desktop.interface icon-theme "Dracula"
else
  echo "Skipping icons installation"
fi

###############################################################################
# Install Dracula Wallpaper

if test ! -f ~/wallpaper; then
  cp ~/.config/files/dracula-custom-gradient.png ~/wallpaper
fi

echo "Sucess!"
echo "Make sure to set Dracula-purple-solid style in kvantum"
echo "Make sure to set kvantum style in qt5ct"
