# Yakuake Startup Configuration

This document outlines how to configure Yakuake to start automatically with predefined tabs on boot.

## Overview

Yakuake is a drop-down terminal emulator for KDE. By default, it starts with one tab. This setup configures it to start with multiple tabs running specific commands.

## Files Involved

- `~/bin/yakuake_startup.sh`: The startup script that launches yakuake and configures tabs via D-Bus.

- `~/.config/autostart/yakuake.desktop`: The autostart desktop file to run the script on boot.

## Setup Steps

1. Create the startup script:

   ```bash
   # Create directory if not exists
   mkdir -p ~/bin

   # Create the script with the content below
   cat > ~/bin/yakuake_startup.sh << 'EOF'
   #!/bin/bash

   echo "Starting yakuake script at $(date)" >> /tmp/yakuake_debug.log

   yakuake &

   echo "Yakuake launched" >> /tmp/yakuake_debug.log

   sleep 5  # wait for yakuake to start

   echo "Sleep done" >> /tmp/yakuake_debug.log

   if pgrep yakuake > /dev/null; then
       echo "Yakuake is running" >> /tmp/yakuake_debug.log
   else
       echo "Yakuake is not running" >> /tmp/yakuake_debug.log
       exit 1
   fi

   # First tab (session 0): set title and run yazi
   echo "Configuring first tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:0 string:"yazi"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:0 string:"yazi"

   # Add second tab: alt+c, run fzf directory finder
   echo "Configuring second tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:1 string:"alt+c"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:1 string:"eval $FZF_ALT_C_COMMAND | fzf $FZF_ALT_C_OPTS"

   # Add third tab: ctrl+c, run eza
   echo "Configuring third tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:2 string:"ctrl+c"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:2 string:"eza"

   # Add fourth tab: fresh, run fresh
   echo "Configuring fourth tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:3 string:"fresh"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:3 string:"fresh"

   echo "Script completed" >> /tmp/yakuake_debug.log

   echo "Toggling window" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/window org.kde.yakuake.toggleWindowState
   EOF

   # Make executable
   chmod +x ~/bin/yakuake_startup.sh
   ```

2. Ensure the autostart desktop file exists and is configured:

   The `~/.config/autostart/yakuake.desktop` should have:

   ```
   [Desktop Entry]
   Type=Application
   Name=Yakuake
   Comment=Quake-style terminal emulator
   Exec=~/bin/yakuake_startup.sh
   Icon=yakuake
   Terminal=false
   Categories=System;TerminalEmulator;
   X-KDE-Autostart-Phase=2
   X-KDE-StartupNotify=false
   ```

   If it doesn't exist, create it with the above content.

## Tabs Configuration

- Tab 1: "yazi" - Runs the yazi file manager.

- Tab 2: "alt+c" - Runs fzf directory finder.

- Tab 3: "ctrl+c" - Runs eza (ls replacement).

- Tab 4: "fresh" - Runs fresh (assuming it's installed).

## Troubleshooting

- If yakuake doesn't start, check `/tmp/yakuake_debug.log` for errors.

- Ensure D-Bus session is available.

- The script uses phase 2 to start after the desktop is ready.

- If the window doesn't show, the toggle command should display it.

## Notes

- This setup assumes yazi, fzf, eza, fresh are installed.

- Customize the commands as needed.
