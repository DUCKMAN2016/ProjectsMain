#!/bin/bash

# Stop Plasma
kquitapp6 plasmashell
sleep 2

# Backup current config
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc.old

# Remove old panel configurations
sed -i '/^\[Containments\]\[2\]/,/^\[Containments\]\[3\]/d' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
sed -i '/^\[Containments\]\[3\]/,/^\[General\]/d' ~/.config/plasma-org.kde.plasma.desktop-appletsrc

# Create panel 1 for first monitor (top, centered, 50% width)
kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "plugin" "org.kde.plasma.panel"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "formfactor" "2"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "location" "3"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "screen" "0"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "height" "38"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "maximumLength" "50%"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2" \
    --key "alignment" "center"

# Add taskmanager to panel 1
kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][2][Applets][3" \
    --key "plugin" "org.kde.plasma.taskmanager"

# Create panel 2 for second monitor (top, centered, 50% width)
kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "plugin" "org.kde.plasma.panel"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "formfactor" "2"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "location" "3"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "screen" "1"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "height" "38"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "maximumLength" "50%"

kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3" \
    --key "alignment" "center"

# Add taskmanager to panel 2
kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments][3][Applets][4" \
    --key "plugin" "org.kde.plasma.taskmanager"

echo "Panels configured. Restarting Plasma..."
sleep 1

# Restart Plasma
DISPLAY=:0 nohup plasmashell > /dev/null 2>&1 &

echo "Done! Panels should now be at the top of each monitor, centered, at 50% width."
