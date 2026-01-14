# XScreenSaver Setup Guide for CachyOS KDE Wayland

## Overview
Complete guide for installing and configuring XScreenSaver on CachyOS KDE with Wayland and XWayland support.

## Installation

### Install XScreenSaver Package
```bash
paru -S xscreensaver --noconfirm
```

### Essential Components Included
- **xscreensaver** - Main screensaver daemon and locker
- **200+ built-in screensavers** - Classic X11 screensavers
- **xscreensaver-settings** - GUI configuration tool
- **xscreensaver daemon** - Background process

## Configuration for Wayland/XWayland

### Desktop Launcher Creation
```bash
# Copy to Desktop
cp /usr/share/applications/xscreensaver-settings.desktop ~/Desktop/

# Make executable
chmod +x ~/Desktop/xscreensaver-settings.desktop

# Update for Wayland compatibility
sed -i 's|Exec=xscreensaver-settings|Exec=GDK_BACKEND=x11 xscreensaver-settings|' ~/Desktop/xscreensaver-settings.desktop
sed -i 's|Icon=xscreensaver|Icon=/usr/share/pixmaps/xscreensaver.png|' ~/Desktop/xscreensaver-settings.desktop
sed -i '/NotShowIn=KDE;GNOME;/d' ~/Desktop/xscreensaver-settings.desktop
```

### System Applications Menu Updates
```bash
# Update system launcher for Wayland compatibility
sudo sed -i 's|Exec=xscreensaver-settings|Exec=GDK_BACKEND=x11 xscreensaver-settings|' /usr/share/applications/xscreensaver-settings.desktop
sudo sed -i 's|Icon=xscreensaver|Icon=/usr/share/pixmaps/xscreensaver.png|' /usr/share/applications/xscreensaver-settings.desktop
sudo sed -i '/NotShowIn=KDE;GNOME;/d' /usr/share/applications/xscreensaver-settings.desktop

# Update main xscreensaver launcher
sudo sed -i 's|Exec=xscreensaver|Exec=GDK_BACKEND=x11 xscreensaver|' /usr/share/applications/xscreensaver.desktop
sudo sed -i 's|Icon=xscreensaver|Icon=/usr/share/pixmaps/xscreensaver.png|' /usr/share/applications/xscreensaver.desktop

# Refresh desktop database
sudo update-desktop-database /usr/share/applications/
```

## Usage

### Start XScreenSaver Daemon
```bash
# Start manually
xscreensaver -no-splash &

# Or use the settings script
./xscreensaver-settings.sh
```

### Settings Script
Create `/usr/local/bin/xscreensaver-settings.sh`:
```bash
#!/bin/bash

# Start xscreensaver daemon if not running
if ! pgrep -x "xscreensaver" > /dev/null; then
    xscreensaver -no-splash &
    sleep 2
fi

# Force X11 for the settings dialog
GDK_BACKEND=x11 xscreensaver-settings
```

### Available Modes
- **Screensaver Mode**: `bonsai.sh --screensaver` (if using bonsai)
- **Settings Dialog**: `GDK_BACKEND=x11 xscreensaver-settings`
- **Daemon**: `xscreensaver -no-splash`

## Wayland Compatibility Notes

### Known Limitations
- Screenshots and fading not supported on Wayland KDE
- Some visual effects may be limited
- XWayland provides compatibility layer

### Required Workarounds
- Use `GDK_BACKEND=x11` for all GUI components
- Force X11 backend for settings dialog
- Remove KDE/GNOME exclusions from desktop files

## Autostart Configuration (Optional)

### Enable Autostart (Working Configuration)
```bash
# Create robust autostart configuration
cat > ~/.config/autostart/xscreensaver.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=XScreenSaver
Comment=XScreenSaver daemon
Exec=/home/duck/.config/autostart/xscreensaver-daemon.sh
Icon=xscreensaver
Terminal=false
Categories=Screensaver;Security;
X-KDE-Autostart-Phase=2
X-KDE-StartupNotify=false
Hidden=false
NoDisplay=false
EOF

# Create startup script with display handling
cat > ~/.config/autostart/xscreensaver-daemon.sh << 'EOF'
#!/bin/bash

# XScreenSaver daemon startup script for Wayland
# Wait for XWayland to be ready before starting

# Wait for Wayland and XWayland to initialize
sleep 15

# Set DISPLAY environment variable for XWayland
export DISPLAY=:0

# Check if XWayland is ready
if ! xset q &>/dev/null; then
    echo "XWayland not ready, waiting longer..."
    sleep 10
fi

# Check if xscreensaver is already running
if ! pgrep -x "xscreensaver" > /dev/null; then
    echo "Starting XScreenSaver daemon for display $DISPLAY..."
    
    # Start xscreensaver daemon with explicit display
    xscreensaver -no-splash -display "$DISPLAY" &
    
    # Wait a moment for daemon to initialize
    sleep 5
    
    # Verify it's running
    if pgrep -x "xscreensaver" > /dev/null; then
        echo "XScreenSaver daemon started successfully on $DISPLAY"
    else
        echo "Failed to start XScreenSaver daemon"
    fi
else
    echo "XScreenSaver daemon already running"
fi
EOF

# Make scripts executable
chmod +x ~/.config/autostart/xscreensaver-daemon.sh
chmod +x ~/.config/autostart/xscreensaver.desktop

# Create Plasma workspace backup (optional but recommended)
mkdir -p ~/.config/plasma-workspace

cat > ~/.config/plasma-workspace/xscreensaver-startup.sh << 'EOF'
#!/bin/bash

# Plasma workspace startup script for XScreenSaver
# This runs when Plasma desktop starts

# Wait for desktop to fully initialize
sleep 20

# Set DISPLAY for XWayland
export DISPLAY=:0

# Check if XWayland is ready
if ! xset q &>/dev/null; then
    echo "XWayland not ready for xscreensaver startup"
    exit 1
fi

# Start XScreenSaver if not running
if ! pgrep -x "xscreensaver" > /dev/null; then
    echo "Starting XScreenSaver daemon from Plasma workspace..."
    xscreensaver -no-splash -display "$DISPLAY" &
fi
EOF

chmod +x ~/.config/plasma-workspace/xscreensaver-startup.sh
```

### Manual Autostart File (Alternative)
Create `~/.config/autostart/xscreensaver.desktop`:
```ini
[Desktop Entry]
Type=Application
Name=XScreenSaver
Exec=GDK_BACKEND=x11 xscreensaver -no-splash -display :0
Icon=/usr/share/pixmaps/xscreensaver.png
Terminal=false
Categories=Screensaver;Security;
X-KDE-Autostart-Phase=2
X-KDE-StartupNotify=false
```

## Troubleshooting

### Desktop Icons Not Appearing
```bash
# Refresh KDE desktop
dbus-send --type=method_call --dest=org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript string:"var allDesktops = desktops(); for (i=0;i<allDesktops.length;i++) { d = allDesktops[i]; d.reloadConfiguration(); }"

# Or restart Plasma
killall plasmashell && plasmashell &
```

### Applications Menu Not Updated
```bash
# Update desktop database
sudo update-desktop-database /usr/share/applications/

# Reboot if changes don't appear
```

### Verify Installation
```bash
# Check running processes
ps aux | grep xscreensaver

# Test settings dialog
GDK_BACKEND=x11 xscreensaver-settings

# Verify package installation
pacman -Ql xscreensaver | grep -E "(bin|share/applications)"
```

## Files and Locations

### System Files
- `/usr/bin/xscreensaver` - Main daemon
- `/usr/bin/xscreensaver-settings` - Settings GUI
- `/usr/share/applications/xscreensaver*.desktop` - Application launchers
- `/usr/share/pixmaps/xscreensaver.png` - Icon file
- `/usr/share/xscreensaver/config/` - Screensaver configurations

### User Files
- `~/.xscreensaver` - User configuration file
- `~/Desktop/xscreensaver-settings.desktop` - Desktop launcher
- `~/.config/autostart/xscreensaver.desktop` - Autostart entry (optional)

### Script Files
- `/usr/local/bin/xscreensaver-settings.sh` - Settings launcher script

## Features

### Built-in Screensavers Include
- **Classic**: Matrix, Star Wars, phosphor terminal
- **3D**: OpenGL demos, fractals, geometric patterns
- **Abstract**: Particle systems, artistic generators
- **Retro**: Vintage computer simulations
- **Nature**: Organic growth patterns, simulations

### Configuration Options
- Screen blanking timeout
- Power management integration
- Lock screen settings
- Screensaver selection and cycling
- Visual effects and performance tuning

## Integration with KDE

### Plasma Compatibility
- Works via XWayland compatibility layer
- Desktop icons and application menu integration
- KDE system settings integration (limited)

### Alternative KDE Solutions
- Consider KDE's built-in screen locking
- Use KDE's power management settings
- Combine with KDE's session management

## Security Notes

### Screen Locking
- XScreenSaver provides robust screen locking
- Password protection integration
- Secure authentication methods

### Privacy Considerations
- Screensaver content visibility
- Lock screen timeout configuration
- System resource usage monitoring

## Performance Optimization

### Resource Usage
- Monitor CPU and memory usage
- Disable resource-intensive screensavers
- Configure appropriate timeouts

### System Integration
- Balance with KDE power management
- Avoid conflicts with native KDE screen locking
- Optimize for laptop battery life

## Conclusion

XScreenSaver provides comprehensive screensaver functionality on CachyOS KDE Wayland through XWayland compatibility. With proper configuration, it offers extensive customization options and reliable screen locking capabilities.

For updates and additional configurations, refer to the official XScreenSaver documentation and CachyOS community resources.
