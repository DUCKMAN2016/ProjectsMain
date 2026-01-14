#!/bin/bash

# Stop KDE wallet service
kquitapp6 kwalletd || killall kwalletd

# Remove Samba credentials
rm -rf ~/.cache/samba/* 2>/dev/null
rm -f ~/.local/share/kwalletd/kdewallet.kwl 2>/dev/null

# Remove any saved network mounts
gio mount -l | grep smb | awk '{print $2}' | xargs -I{} gio mount -u {}

echo "SMB credentials cleared. Please restart your computer."
