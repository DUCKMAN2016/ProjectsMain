# CachyOS Global Settings Documentation

## Current System Configuration
- **OS**: CachyOS (Arch-based Linux)
- **Desktop Environment**: KDE Plasma
- **Kernel**: 6.18.2-1-cachyos (CachyOS optimized kernel)
- **Kernel Features**: EEVDF + LTO + AutoFDO + Propeller Cachy Sauce
- **Compiler**: Clang 21.1.6 with LLD 21.1.6
- **Build Date**: December 19, 2025
- **Date**: January 1, 2026

## Global Theme Settings

### Current Theme Configuration
- **Global Theme**: KDE-Story-Dark-Global-6
- **Color Scheme**: Custom dark with blue accents
- **Window Manager**: KWin (KDE)
- **Display Server**: Wayland

### Theme Packages Installed
- `cachyos-nord-gtk-theme-git` - Nord GTK theme
- `kvantum` - Qt theme engine  
- `kvantum-theme-nordic-git` - Nordic Kvantum theme
- `cachyos-wallpapers` - CachyOS wallpapers
- `qt5ct` & `qt6ct` - Qt configuration tools

### Color Scheme Details
**Primary Colors**:
- **Background**: Dark gray tones (RGB 20-41)
- **Foreground**: White/light gray (RGB 161-252)
- **Accent/Highlight**: Blue (RGB 61,174,233)
- **Selection**: Blue background with white text

**Application Colors**:
- **Windows**: Dark gray (32,35,38) backgrounds
- **Buttons**: Medium dark (41,44,48) with blue accents
- **Views**: Very dark (20,22,24) backgrounds
- **Headers**: Medium dark (41,44,48) backgrounds

## System Settings

### Display Configuration
- **Resolution**: Dual monitors (1366x768 each)
- **Layout**: Left monitor (HDMI-A-3), Right monitor (HDMI-A-2)
- **Refresh Rate**: 59.79Hz on both monitors

### Panel Configuration (Taskbar)
- **Number of Panels**: 2 (one per monitor)
- **Position**: Top of screen
- **Width**: Custom (not full width)
- **Opacity**: Translucent
- **Access**: Show panel configuration available
- **Widgets**: Application launcher, task manager, system tray, clock

### Desktop Environment Settings
- **File Manager**: Dolphin (detailed list view, directories first)
- **Default Browser**: Brave Browser
- **Terminal**: Konsole
- **Application Launcher**: Kickoff (default KDE)

### Window Decoration Settings
- **Titlebar Buttons**: Left side - Close, Keep Below, Keep Above
- **Titlebar Buttons**: Right side - Pin to All Desktops
- **Removed**: Window menu button from titlebar
- **Removed**: Minimize and Maximize buttons
- **Added**: Pin to All Desktops, Keep Below, Keep Above buttons
- **Layout**: Custom button arrangement for workflow efficiency

### Desktop Effects Settings
- **Blur**: Enabled (configured with cog wheel settings)
- **Hide Cursor**: Enabled
- **Desaturate**: Enabled
- **Fall Apart**: Enabled
- **Geometry Change**: Enabled
- **Highlight Screen Edges**: Enabled
- **Translucency**: Enabled
- **Wobbly Windows**: Enabled
- **Dialog Parent**: Enabled
- **Dim Screen**: Enabled
- **Overview**: Enabled
- **Magic Lamp**: Enabled (located under Animations → Window Minimize effect)
- **Status**: All listed effects are active

### Transparency Configuration
- **Location**: Global Themes → Application Style → Transparency tab
- **Access**: Edit icon (pencil) to modify settings
- **Setting**: Custom transparency configured
- **Integration**: Linked with Blur effect for visual consistency

### KWin Effects Configuration
- **Config File**: `/home/duck/.config/kwinrc`
- **Section**: [Plugins]
- **Magic Lamp Location**: System Settings → Workspace → Desktop Effects → Animations → Window Minimize
- **Setting**: Change "Window Minimize" effect to "Magic Lamp"
- **Other Effects**: All effects managed through KWin plugin system
- **Access**: Effects can be toggled via System Settings → Desktop Effects

## Application Settings

### KDE Applications
- **Dolphin**: Detail tree view, hidden files hidden by default
- **Konsole**: Default KDE terminal profile
- **Kate**: Default KDE text editor
- **Okular**: Default PDF viewer

### Third-Party Applications
- **Brave Browser**: Default web browser
- **Visual Studio Code**: Code editor
- **Windsurf**: AI-powered development environment
- **NordVPN**: VPN client with GUI

## System Services

### Enabled Services
- `sddm.service` - Display manager
- `NetworkManager.service` - Network management
- `bluetooth.service` - Bluetooth support
- `ufw.service` - Firewall
- `power-profiles-daemon.service` - Power management

### Disabled Services
- (None currently disabled - avahi-daemon is active)

## Audio Configuration
- **Audio System**: PipeWire
- **Audio Sink**: HDMI output to Samsung monitor
- **PulseAudio**: Compatible layer running

## Network Configuration
- **DNS**: Quad9 (9.9.9.9) for security
- **Connection**: NetworkManager handles all connections
- **VPN**: NordVPN available via GUI and CLI

## Custom Scripts & Shortcuts
- `~/launch_rainbow.sh` - Rainbow emulator launcher
- `~/launch_kaypro.sh` - Kaypro emulator launcher
- `restart-plasma.sh` - Plasma session restart script

## Recent Changes Log

### January 1, 2026
- Created this global settings documentation file
- Confirmed current theme configuration (KDE-Story-Dark-Global-6)
- Documented system service status
- Updated window decoration settings:
  - Removed window menu button from titlebar
  - Removed Minimize and Maximize buttons
  - Added Pin to All Desktops button on right side
  - Added Keep Below and Keep Above buttons on left side
  - Arranged titlebar buttons: Close, Keep Below, Keep Above (left side)
- Configured desktop effects:
  - Enabled 12 visual effects including Blur, Wobbly Windows, Translucency
  - Activated window management effects (Hide Cursor, Dialog Parent, Dim Screen)
  - Enabled special effects (Fall Apart, Geometry Change, Overview, Magic Lamp)
  - Configured Blur effect with advanced cog wheel settings
  - Set up transparency via Global Themes → Application Style → Transparency tab
  - Noted Magic Lamp effect is active but may be categorized differently in settings
- Configured panel (taskbar) settings:
  - Set position to Top of screen
  - Configured custom width (not full width)
  - Applied translucent opacity
  - Enabled show panel configuration access

### Previous Changes (from other documentation)
- Disabled Avahi daemon for network discovery issues
- Configured SMB access using NetBIOS instead of mDNS
- Set up MAME emulator window centering
- Configured dual monitor wallpaper setup

## Backup Locations
- **KDE Settings**: `/run/media/duck/extra/User/Downloads/ProjectsMain/KDE-CachyOS/config/`
- **System Info**: `/home/duck/system-info/`
- **Wallpapers**: `/home/duck/Pictures/wallpapers/`

## Notes
- Using KDE Plasma with Wayland display server
- KDE-Story-Dark-Global-6 theme for consistent dark appearance
- System optimized for desktop use with emulators and development tools
- Network configured for security and gaming performance
- Avahi daemon is currently active (not disabled)

---
**Last Updated**: January 1, 2026
**System**: CachyOS with KDE Plasma
**Status**: Documentation created ✅
