# Power Off & Reboot Icons Setup

This document outlines the setup of instant Power Off and Reboot desktop and taskbar icons for CachyOS KDE Plasma.

## Overview

Custom desktop and taskbar icons that provide instant system power control without waiting for the standard 30-second shutdown countdown.

## Files Created

### Desktop Icons
- **Location**: `/home/duck/Desktop/`
- **Power Off.desktop**: Instant shutdown icon
- **Reboot.desktop**: Instant reboot icon

### Taskbar Integration
- **Location**: `~/.local/share/applications/`
- **Configuration**: `~/.config/plasma-org.kde.plasma.desktop-appletsrc`
- **Panel**: Added to main taskbar launcher list

### Custom Icons
- **power-off.jpg**: Custom Power Off icon image
- **reboot.jpg**: Custom Reboot icon image
- **Source**: `/home/duck/Downloads/`

## Icon Specifications

### Power Off Icon
```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Power Off
Comment=Instant power off system
Exec=poweroff
Icon=/home/duck/Downloads/power-off.jpg
Terminal=false
Categories=System;
StartupNotify=false
```

### Reboot Icon
```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Reboot
Comment=Instant reboot system
Exec=reboot
Icon=/home/duck/Downloads/reboot.jpg
Terminal=false
Categories=System;
StartupNotify=false
```

## Installation Commands

### Create Desktop Icons
```bash
# Create Power Off desktop icon
cat > ~/Desktop/Power\ Off.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Power Off
Comment=Instant power off system
Exec=poweroff
Icon=/home/duck/Downloads/power-off.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Create Reboot desktop icon
cat > ~/Desktop/Reboot.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Reboot
Comment=Instant reboot system
Exec=reboot
Icon=/home/duck/Downloads/reboot.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Make executable
chmod +x ~/Desktop/Power\ Off.desktop ~/Desktop/Reboot.desktop
```

### Add to Taskbar
```bash
# Copy to applications directory
cp ~/Desktop/Power\ Off.desktop ~/Desktop/Reboot.desktop ~/.local/share/applications/

# Update Plasma configuration (manual edit required)
# Add to launchers line in plasma-org.kde.plasma.desktop-appletsrc:
# ,applications:Power Off.desktop,applications:Reboot.desktop

# Restart Plasma shell
kquitapp6 plasmashell 2>/dev/null || kquitapp5 plasmashell 2>/dev/null || true
sleep 3 && plasmashell &
```

## Usage Instructions

### Desktop Icons
- **Double-click** to execute
- **Power Off**: Instant shutdown (~3 seconds)
- **Reboot**: Instant restart

### Taskbar Icons
- **Single-click** to execute
- Same functionality as desktop icons
- Located at end of taskbar launcher list

## ⚠️ Important Safety Warning

**ALWAYS SAVE YOUR WORK before using these icons!**

- These commands execute immediately
- No confirmation dialog
- No 30-second countdown
- System actions cannot be cancelled once initiated

## Backup Files

The following files are backed up in the repository:
- `config/plasma-org.kde.plasma.desktop-appletsrc` - Plasma configuration
- `config/Power Off.desktop` - Desktop icon
- `config/Reboot.desktop` - Desktop icon
- `config/power-off.jpg` - Custom icon image
- `config/reboot.jpg` - Custom icon image

## Integration with Post-Install Script

These icons can be automatically created during system setup by adding the installation commands to the comprehensive post-install script.

## References

- KDE Plasma Desktop File Specification: https://specifications.freedesktop.org/desktop-entry-spec/
- Plasma Applet Configuration: https://userbase.kde.org/Plasma/Tips_and_Tricks

---

*Created: January 11, 2026*
*Compatible: CachyOS KDE Plasma*
