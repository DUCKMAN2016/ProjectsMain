# ProjectsMain

This repository contains various projects, scripts, and configurations for CachyOS KDE Plasma system setup and maintenance.

## 📁 Repository Structure

### 🚀 **Post-Install Scripts**
- **`Post-Install-CachyOS/`** - Complete CachyOS system setup automation
  - `cachyos-comprehensive-post-install.sh` - Full system recreation script
  - `README.md` - Detailed documentation and usage instructions
  - `backups/` - Configuration backups and unimatrix setup files

### 🖥️ **Desktop Configuration**
- **`Desktop-Icons/`** - Desktop launcher icons and shortcuts
- **`KDE-CachyOS/`** - KDE Plasma configuration files
- **`config/`** - System configuration files
- **`lock-screen-config/`** - Lock screen customization

### 🛠️ **Scripts & Utilities**
- **`Scripts/`** - Utility scripts for system management
- **`lost-scripts/`** - Archived/legacy scripts
- **`GITHUB/`** - GitHub-related scripts and tools

### 🎮 **Emulators**
- **`emulators/dosbox-x/`** - DOSBox-X configurations for retro computing
  - `myz80.conf` - Optimized DOSBox-X config for MYZ80 Z80/CP/M emulator
  - `myz80-dosbox-x.sh` - Launcher script with auto-mount
  - `myz80.desktop` - Desktop icon with authentic MYZ80 branding
  - `README.md` - Complete setup and usage documentation

### 📚 **Documentation**
- **`docs/`** - Additional documentation files
- **`FreHd/`** - FreeHD project files
- **`gz-archives/`** - Compressed archives

## 🎯 Key Features

### Unimatrix Dual Monitor Setup
- **Matrix effect** with Japanese katakana characters
- **Dual monitor support** with automatic launcher
- **Green color scheme** with large font
- **Easy control** with `unimatrix-simple` command

### MYZ80 Z80/CP/M Emulation
- **DOSBox-X integration** with optimized configuration
- **Auto-mount** and auto-launch of MYZ80 emulator
- **Perfect window positioning** for multi-monitor setups
- **Authentic MYZ80 branding** with original icons

### System Automation
- **Complete post-install** script for fresh CachyOS setup
- **Desktop icons** for applications and system controls
- **KDE configuration** with themes and effects
- **Network storage** auto-mount configuration

## 🚀 Quick Start

### For Fresh CachyOS Installation:
```bash
# Clone this repository
git clone https://github.com/DUCKMAN2016/ProjectsMain.git
cd ProjectsMain/Post-Install-CachyOS

# Run the comprehensive post-install script
./cachyos-comprehensive-post-install.sh
```

### For MYZ80 Z80/CP/M Emulation:
```bash
# Install DOSBox-X (required for MYZ80)
yay -S dosbox-x

# Copy configuration to local system
cp emulators/dosbox-x/myz80.conf ~/.config/dosbox-x/
cp emulators/dosbox-x/myz80.desktop ~/Desktop/

# Ensure MYZ80 files are in place
mkdir -p ~/myz80
# Copy your MYZ80 files to ~/myz80/

# Launch MYZ80
./emulators/dosbox-x/myz80-dosbox-x.sh
```

### For Unimatrix Dual Monitor Effect:
```bash
# After post-install setup, run:
unimatrix-simple
```

## 📋 Repository Contents

### Post-Install-CachyOS
- **Scripts**: Complete system automation
- **Documentation**: Comprehensive setup guides
- **Backups**: Configuration files and unimatrix setup

### Scripts Collection
- System utilities and management tools
- Desktop automation scripts
- Network and storage tools

### Emulators
- **DOSBox-X configurations** for retro computing
- **MYZ80 setup** with optimized window management
- **Desktop integration** with authentic icons
- **Multi-monitor support** with proper positioning

### Desktop Configuration
- KDE Plasma themes and effects
- Desktop icons and launchers
- Panel configuration files

## 🔧 Dependencies

### System Requirements:
- CachyOS with KDE Plasma
- Internet connection for package installation
- Sudo access for system modifications

### Required Tools:
- Git for repository management
- Yay for AUR package management
- Konsole for terminal operations

## 📖 Documentation

### Main Documentation:
- `Post-Install-CachyOS/README.md` - Complete setup guide
- `Post-Install-CachyOS/CACHYOS_GLOBAL_SETTINGS.md` - System configuration
- `Post-Install-CachyOS/TERMINAL_TOOLS_SETUP.md` - Terminal setup

### Specialized Guides:
- Unimatrix dual monitor setup documentation
- XScreenSaver configuration for Wayland
- System control icons setup

## 🔄 Updates

### Recent Changes:
- **January 14, 2026**: Added MYZ80 Z80/CP/M emulator with DOSBox-X integration
- **January 14, 2026**: Added unimatrix dual monitor setup
- **January 13, 2026**: Updated with Japanese fonts and terminal tools
- **January 12, 2026**: Post-reinstall session configurations

## 🤝 Contributing

This is a personal repository for system configuration and scripts. Feel free to explore and adapt the scripts for your own use.

## 📞 Support

For issues with the post-install scripts:
1. Check the documentation in `Post-Install-CachyOS/README.md`
2. Review the troubleshooting sections
3. Ensure all prerequisites are met

---

**Repository**: ProjectsMain  
**Purpose**: CachyOS system setup and configuration  
**Maintainer**: DUCKMAN2016  
**Last Updated**: January 14, 2026
