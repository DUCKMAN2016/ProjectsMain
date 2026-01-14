#!/bin/bash

# Backup essential KDE configuration files
mkdir -p config
mkdir -p local/share

# Copy main KDE configuration files
cp -r ~/.config/kdeglobals config/
cp -r ~/.config/plasmarc config/
cp -r ~/.config/kwinrc config/
cp -r ~/.config/plasma-org.kde.plasma.desktop-appletsrc config/
cp -r ~/.config/systemsettingsrc config/
cp -r ~/.config/kcmshellrc config/
cp -r ~/.config/kcminitrc config/
cp -r ~/.config/kcmfonts config/

cp -r ~/.local/share/kwin/scripts local/share/

echo "KDE settings backup completed!"
