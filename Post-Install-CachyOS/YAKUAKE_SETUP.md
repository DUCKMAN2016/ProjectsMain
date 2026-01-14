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

   sleep 10  # wait for yakuake to start

   echo "Sleep done" >> /tmp/yakuake_debug.log

   if pgrep yakuake > /dev/null; then
       echo "Yakuake is running" >> /tmp/yakuake_debug.log
   else
       echo "Yakuake is not running" >> /tmp/yakuake_debug.log
       exit 1
   fi

   # First tab (session 0): set title to shell (regular terminal)
   echo "Configuring first tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:0 string:"shell"

   # Add second tab: yazi, run yazi
   echo "Configuring second tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:1 string:"yazi"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:1 string:"yazi"

   # Add third tab: alt+c, run c
   echo "Configuring third tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:2 string:"alt+c"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:2 string:"c"

   # Add fourth tab: ctrl+c, run eza
   echo "Configuring fourth tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:3 string:"ctrl+c"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:3 string:"eza"

   # Add fifth tab: fresh, run fresh
   echo "Configuring fifth tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:4 string:"fresh"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:4 string:"fresh /home/duck/.zshrc"

   # Add sixth tab: cmatrix
   echo "Configuring sixth tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:5 string:"cmatrix"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:5 string:"unimatrix -c green"

   # Add seventh tab: asciiquarium
   echo "Configuring seventh tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:6 string:"asciiquarium"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:6 string:"asciiquarium"

   # Add eighth tab: bonsai
   echo "Configuring eighth tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:7 string:"bonsai"
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:7 string:"bonsai.sh --live --time 0.5 --life 28 --infinite --wait 3"

   # Add ninth tab: shell
   echo "Configuring ninth tab" >> /tmp/yakuake_debug.log
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
   dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:8 string:"shell"

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

- Tab 1: "shell" - Regular shell terminal.

- Tab 2: "yazi" - Runs yazi file manager.

- Tab 3: "alt+c" - Runs c (eza directory list with preview).

- Tab 4: "ctrl+c" - Runs eza (ls replacement).

- Tab 5: "fresh" - Runs fresh /home/duck/.zshrc.

- Tab 6: "cmatrix" - Runs unimatrix -c green (Matrix effect with Japanese katakana characters).

- Tab 7: "asciiquarium" - Runs asciiquarium.

- Tab 8: "bonsai" - Runs bonsai.

- Tab 9: "shell" - Regular shell terminal.

## Troubleshooting

- If yakuake doesn't start, check `/tmp/yakuake_debug.log` for errors.

- Ensure D-Bus session is available.

- The script uses phase 2 to start after the desktop is ready.

- If the window doesn't show, the toggle command should display it.

## Notes

- This setup assumes yazi, fzf, eza, fresh, unimatrix are installed.

- Customize the commands as needed.

- **Unimatrix Installation**: Install unimatrix for Japanese katakana Matrix effect:
  ```bash
  sudo curl -L https://raw.githubusercontent.com/will8211/unimatrix/master/unimatrix.py -o /usr/local/bin/unimatrix
  sudo chmod a+rx /usr/local/bin/unimatrix
  ```

- **Japanese Fonts**: For proper katakana character display, install Japanese fonts:
  ```bash
  sudo pacman -S noto-fonts-cjk ttf-hanazono adobe-source-han-sans-jp-fonts ttf-sazanami
  ```

- **Japanese Locale**: Generate ja_JP.UTF-8 locale:
  ```bash
  sudo sed -i 's/#ja_JP.UTF-8/ja_JP.UTF-8/' /etc/locale.gen
  sudo locale-gen
  ```

