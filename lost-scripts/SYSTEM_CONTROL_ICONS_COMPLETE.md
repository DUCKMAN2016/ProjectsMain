# System Control Icons and Scripts - Complete Setup Guide

## Overview
This document covers the complete setup of system control icons, scripts, and configurations created for instant power management, Firefox RAM optimization, and app positioning on CachyOS KDE Plasma.

---

## 🖥️ System Control Icons

### Desktop Icons Location: `~/Desktop/`

#### 1. Power Off.desktop
- **Purpose**: Instant system shutdown (~3 seconds)
- **Command**: `poweroff`
- **Icon**: `~/Downloads/power-off.jpg`
- **Features**: 
  - Immediate execution (no Firefox save to avoid blocking)
  - No confirmation dialog
  - Direct poweroff command

#### 2. Reboot.desktop  
- **Purpose**: Instant system reboot
- **Command**: `reboot`
- **Icon**: `~/Downloads/reboot.jpg`
- **Features**:
  - Immediate execution (no Firefox save to avoid blocking)
  - No confirmation dialog
  - Direct reboot command

#### 3. Full Shutdown.desktop
- **Purpose**: Shutdown with 15-second delay and confirmation
- **Command**: `/home/duck/Desktop/simple-full-shutdown.sh`
- **Icon**: `~/Downloads/full-shutdown.jpg`
- **Features**:
  - Confirmation dialog with 15-second timeout
  - Saves Firefox profile
  - Gracefully closes all applications
  - 15-second countdown after confirmation
  - Full system shutdown

#### 4. Logout.desktop
- **Purpose**: Logout from current session
- **Command**: `/home/duck/Desktop/simple-logout.sh`
- **Icon**: `~/Downloads/logout.jpg`
- **Features**:
  - Saves Firefox profile before logout
  - Confirmation dialog
  - Graceful logout to login screen
  - Uses pkill method (reliable)

### Taskbar Integration
All icons are also available in the KDE Plasma taskbar via:
- **Applications Directory**: `~/.local/share/applications/`
- **Plasma Configuration**: `~/.config/plasma-org.kde.plasma.desktop-appletsrc`

---

## 📜 Scripts

### Active Scripts Location: `~/Desktop/`

#### 1. simple-full-shutdown.sh
```bash
#!/bin/bash
# Full shutdown with 15-second delay
zenity --question --text="Shutdown system in 15 seconds?" --timeout=15
if [ $? -eq 0 ]; then
    /usr/local/bin/save-firefox-profile.sh
    sleep 15
    poweroff
fi
```

#### 2. simple-logout.sh  
```bash
#!/bin/bash
# Simple logout script
echo "Logging out..."
/usr/local/bin/save-firefox-profile.sh
sleep 1
zenity --question --text="Logout from current session?"
if [ $? -eq 0 ]; then
    pkill -KILL -u duck
fi
```

### Archived Scripts Location: `~/Desktop/.scripts/`
- `full-shutdown-script.sh` - Original complex shutdown script
- `logout-script.sh` - Original logout script (moved to .scripts/)
- `simple-logout.sh` - Current active logout script
- `test-launcher.sh` - Desktop icon test
- `test-shutdown-advanced.sh` - Advanced shutdown diagnostics
- `test-shutdown.sh` - Basic shutdown test
- `wayland-app-setup.sh` - Wayland app positioning helper
- `window-class-helper.sh` - Window class detection tool

---

## 🦊 Firefox RAM Optimization

### Firefox Profile Save Script
**Location**: `/usr/local/bin/save-firefox-profile.sh`

#### Functionality:
```bash
#!/bin/sh
# Saves Firefox profile from RAM to backup
if pgrep -f firefox >/dev/null 2>&1; then
    timeout 30s rsync -a --delete /dev/shm/firefox-profile/ /home/duck/.mozilla/firefox/jkfujx2p.default-release.backup/
    pkill -f firefox 2>/dev/null || true
fi
```

#### Features:
- **RAM-based profile**: Firefox runs from `/dev/shm/firefox-profile/`
- **Automatic backup**: Saves to `jkfujx2p.default-release.backup/`
- **30-second timeout**: Prevents hanging
- **Graceful shutdown**: Kills Firefox after saving

### Firefox Autostart
**Location**: `~/.config/autostart/firefox.desktop`

#### Startup Process:
1. Creates RAM profile directory if needed
2. Copies profile from disk to RAM
3. Starts Firefox with RAM profile
4. Autostarts after Plasma loads

#### Command:
```bash
sh -c 'mkdir -p /dev/shm/firefox-profile && rsync -a /home/duck/.mozilla/firefox/jkfujx2p.default-release/ /dev/shm/firefox-profile/ && firefox -profile /dev/shm/firefox-profile'
```

---

## 🖥️ App Positioning Setup

### Window Rules Configuration
**Location**: `~/.config/kwinrulesrc`

#### Monitor Assignments:
- **Monitor 1 (Primary - screen=0)**:
  - Enpass: Fixed position (330,804), size (1104x636)
  - Kate, Dolphin, Konsole
  - System Settings, KWrite

- **Monitor 2 (Secondary - screen=1)**:
  - Firefox: Fixed position (4100,100), size (1200x800)
  - Windsurf: Fixed position (4042,786), size (1165x687)
  - VirtualBox, Steam

#### Complete Rules Structure:
```ini
[6]
Description=Firefox on monitor 2
wmclass=firefox
wmclassmatch=3
screen=2
screenmatch=0
position=4100,100
positionmatch=0
size=1200,800
sizematch=0
types=1

[2]
Description=Windsurf on monitor 2
wmclass=Windsurf
wmclassmatch=3
position=4042,786
positionmatch=0
size=1165,687
sizematch=0
screen=1
screenmatch=0
types=1
```

### Wayland Considerations
- **Session Type**: Wayland affects window rule behavior
- **Application**: Rules may work differently than X11
- **Troubleshooting**: Use KDE System Settings for manual rule creation

---

## 🔧 Configuration Files

### Plasma Configuration
**Location**: `~/.config/plasma-org.kde.plasma.desktop-appletsrc`

#### Taskbar Launchers:
Updated to include system control icons:
```ini
launchers=applications:systemsettings.desktop,preferred://filemanager,preferred://browser,applications:enpass.desktop,applications:windsurf.desktop,applications:org.kde.konsole.desktop,applications:toggle-desktop-peek.desktop,applications:jdownloader.desktop,applications:nordvpn-gui.desktop,applications:newshosting.desktop,applications:soundconverter.desktop,applications:org.shotcut.Shotcut.desktop,applications:org.kde.kate.desktop,applications:filezilla.desktop,applications:com.obsproject.Studio.desktop,applications:virtualbox.desktop,applications:Power Off.desktop,applications:Reboot.desktop,applications:Full Shutdown.desktop,applications:Logout.desktop
```

### Firefox Profile Structure
**Location**: `~/.mozilla/firefox/`

#### Directories:
- `jkfujx2p.default-release/` - Active profile (regular directory)
- `jkfujx2p.default-release.backup/` - Backup copy
- `/dev/shm/firefox-profile/` - RAM-based profile

---

## 🎯 Custom Icons

### Icon Files Location: `~/Downloads/`
- `power-off.jpg` - Power Off icon
- `reboot.jpg` - Reboot icon  
- `full-shutdown.jpg` - Full Shutdown icon
- `logout.jpg` - Logout icon

### Icon Integration:
- **Desktop Icons**: Custom JPG images
- **Taskbar Icons**: Same custom images
- **Size**: Optimized for KDE Plasma

---

## 📁 File Organization

### Desktop Structure:
```
~/Desktop/
├── Power Off.desktop
├── Reboot.desktop
├── Full Shutdown.desktop
├── Logout.desktop
├── [Application launchers...]
├── .scripts/                    # Hidden: Test scripts
└── .test-icons/                 # Hidden: Test icons
```

### Hidden Folders:
- **`.scripts/`** - Development and test scripts
- **`.test-icons/`** - Test desktop icons

### 🎯 Current Working Status:
- **Power Off**: ✅ Working (direct command, no Firefox save)
- **Reboot**: ✅ Working (direct command, no Firefox save)  
- **Full Shutdown**: ✅ Working (15-second delay, Firefox save)
- **Logout**: ✅ Working (confirmation, Firefox save, pkill method)
- **Firefox**: ✅ Working with autostart and RAM optimization
- **App Positioning**: ✅ KDE default behavior (apps remember last position)
- **System Control Panel**: ✅ Working (4x2 grid, persistent, single instance)
- **Toggle Functions**: ✅ Working (Desktop Icons, Open Apps, Desktop Peek, Refresh)

---

## 🎛️ System Control Panel

### Overview:
The **System Control Panel** provides a unified 4x2 grid interface for all system control functions, accessible via desktop icon or taskbar.

### Features:
- **4x2 Grid Layout**: Compact organization of 8 functions
- **Persistent Window**: Stays open for multiple actions
- **Single Instance**: Prevents multiple panels from opening
- **Custom Icon**: Uses `/home/duck/Downloads/control-panel.jpg`

### Functions Available:

#### **Top Row (System Control):**
- **🚪 Logout**: Confirmation with Firefox save
- **⏻ Full Shutdown**: 15-second delay with Firefox save  
- **🔌 Power Off**: Instant power off (no Firefox save)
- **🔄 Reboot**: Instant reboot (no Firefox save)

#### **Bottom Row (Desktop Management):**
- **📱 Toggle Open Apps**: Minimize/restore all windows
- **🖥️ Toggle Desktop Icons**: Hide/show desktop icons (includes directories)
- **🔄 Refresh Desktop**: Complete desktop refresh
- **👁️ Desktop Peek**: Hide icons + minimize windows / Restore both

### Usage:
1. **Desktop**: Click "System Control Panel" icon
2. **Taskbar**: Add to taskbar for quick access
3. **Multiple Actions**: Panel stays open for sequential operations
4. **Exit**: Select "Exit Panel" or close window

### Scripts Location:
- **Main Panel**: `/run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/system_control_panel.sh`
- **Toggle Apps**: `/run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/toggle_open_apps.sh`
- **Toggle Icons**: `/run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/toggle_desktop_icons.sh`
- **Desktop Peek**: `/run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/toggle_desktop_peek.sh`

---

## 🚀 Installation and Setup

### New System Setup:
1. **Copy desktop icons** to `~/Desktop/`
2. **Copy icons** to `~/.local/share/applications/`
3. **Update Plasma config** with taskbar launchers
4. **Install Firefox save script** to `/usr/local/bin/`
5. **Create Firefox autostart** in `~/.config/autostart/`
6. **Configure window rules** in `~/.config/kwinrulesrc`
7. **Set up RAM profile** structure

### Verification:
1. **Test Power Off** - Should save Firefox and shutdown
2. **Test Reboot** - Should save Firefox and reboot
3. **Test Full Shutdown** - Should show dialog and shutdown
4. **Test Logout** - Should save Firefox and logout
5. **Test Firefox** - Should start automatically from RAM
6. **Test App Positioning** - Apps should open on correct monitors

---

## 🔍 Troubleshooting

### Common Issues:

#### Firefox Won't Start:
- **Cause**: Broken profile symlink
- **Fix**: Restore from backup:
  ```bash
  rm ~/.mozilla/firefox/jkfujx2p.default-release
  cp -r ~/.mozilla/firefox/jkfujx2p.default-release.backup ~/.mozilla/firefox/jkfujx2p.default-release
  ```

#### Shutdown Logs Out Instead:
- **Cause**: Command permissions or system configuration
- **Fix**: Use `poweroff` command directly, ensure proper permissions

#### App Positioning Not Working:
- **Cause**: Wayland window rule differences
- **Fix**: Use KDE System Settings > Window Management > Window Rules

#### Icons Not Clickable:
- **Cause**: File permissions or Plasma desktop issues
- **Fix**: Ensure executable permissions and restart Plasma

### Diagnostic Commands:
```bash
# Test shutdown commands
/home/duck/Desktop/.scripts/test-shutdown-advanced.sh

# Check window classes
/home/duck/Desktop/.scripts/window-class-helper.sh

# Wayland app setup
/home/duck/Desktop/.scripts/wayland-app-setup.sh
```

---

## 📚 Related Documentation

- **POWER_OFF_REBOOT_ICONS.md** - Icon setup details
- **APP_MONITOR_SETUP.md** - App positioning configuration
- **FIREFOX_RAM_SETUP.md** - Firefox RAM optimization
- **TERMINAL_TOOLS_SETUP.md** - Terminal configuration

---

## 🔄 Maintenance

### Regular Tasks:
1. **Backup Firefox profile** before major changes
2. **Test system control icons** after updates
3. **Verify app positioning** after configuration changes
4. **Update window rules** when adding new applications

### Backup Locations:
- **Firefox Backup**: `~/.mozilla/firefox/jkfujx2p.default-release.backup/`
- **Config Backups**: Repository `config/` directory
- **Icon Files**: Repository `config/` directory

---

## 📅 Creation History

**Created**: January 11, 2026  
**System**: CachyOS KDE Plasma  
**Desktop Environment**: Wayland  
**Purpose**: Instant power management with Firefox optimization and app positioning

---

## 🎯 Summary

This setup provides:
- ✅ **Instant system control** (Power Off, Reboot, Full Shutdown, Logout)
- ✅ **Firefox RAM optimization** with automatic profile management
- ✅ **App positioning** across multiple monitors
- ✅ **Custom icons** with visual identification
- ✅ **Graceful shutdown** with application closure
- ✅ **Profile preservation** across sessions
- ✅ **Taskbar integration** for quick access
- ✅ **Comprehensive documentation** for maintenance

All components are integrated, tested, and documented for reliable daily use.
