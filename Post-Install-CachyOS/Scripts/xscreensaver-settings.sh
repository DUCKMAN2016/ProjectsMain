#!/bin/bash

# Start xscreensaver daemon if not running
if ! pgrep -x "xscreensaver" > /dev/null; then
    xscreensaver -no-splash &
    sleep 2
fi

# Force X11 for the settings dialog
GDK_BACKEND=x11 xscreensaver-settings
