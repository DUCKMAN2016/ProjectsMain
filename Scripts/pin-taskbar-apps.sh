#!/bin/bash

# Script to pin applications to KDE Plasma taskbar

# Get the taskbar applet ID
TASKBAR_ID=$(grep -m1 'org.kde.plasma.taskmanager' ~/.config/plasma-org.kde.plasma.desktop-appletsrc | grep '\[Applets' | sed 's/.*\[Applets\]\[\([0-9]*\)\].*/\1/')

if [ -z "$TASKBAR_ID" ]; then
    echo "Could not find taskbar applet ID"
    exit 1
fi

echo "Found taskbar applet ID: $TASKBAR_ID"

# List of applications to pin (desktop file names)
APPS=(
    "org.kde.discover.desktop"
    "brave-browser.desktop"
    "steam.desktop"
    "mame.desktop"
    "ipscan.desktop"
    "jdownloader.desktop"
    "newshosting.desktop"
    "org.remmina.Remmina.desktop"
    "info.bibletime.BibleTime.desktop"
    "virtualbox.desktop"
    "org.kde.falkon.desktop"
    "nordvpn.desktop"
    "nordvpn-gui.desktop"
    "yuki-iptv.desktop"
)

# Build LauncherUrls string
LAUNCHER_URLS=""
for app in "${APPS[@]}"; do
    if [ -f "/usr/share/applications/$app" ] || [ -f "$HOME/.local/share/applications/$app" ]; then
        LAUNCHER_URLS="${LAUNCHER_URLS}applications:${app},"
    fi
done

# Remove trailing comma
LAUNCHER_URLS="${LAUNCHER_URLS%,}"

if [ -z "$LAUNCHER_URLS" ]; then
    echo "No applications found to pin"
    exit 1
fi

echo "Pinning applications: $LAUNCHER_URLS"

# Update the config file
kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
    --group "Containments" \
    --group "1" \
    --group "Applets" \
    --group "$TASKBAR_ID" \
    --group "Configuration" \
    --key "LauncherUrls" "$LAUNCHER_URLS"

echo "Applications pinned. Restarting Plasma..."
kquitapp6 plasmashell
sleep 2
DISPLAY=:0 nohup plasmashell > /dev/null 2>&1 &

echo "Done!"
