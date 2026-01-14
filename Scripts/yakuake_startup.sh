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

# Add fifth tab: asciiquarium, run asciiquarium
echo "Configuring fifth tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:4 string:"asciiquarium"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:4 string:"asciiquarium"

# Add sixth tab: cmatrix, run cmatrix
echo "Configuring sixth tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:5 string:"cmatrix"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:5 string:"cmatrix"

# Add seventh tab: bonsai, run bonsai.sh with options
echo "Configuring seventh tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:6 string:"bonsai"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:6 string:"bonsai.sh --live --time 0.5 --life 28 --infinite --wait 3"

echo "Script completed" >> /tmp/yakuake_debug.log

echo "Toggling window" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/window org.kde.yakuake.toggleWindowState
