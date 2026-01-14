# CachyOS Post-Install Scripts

This collection of scripts automates the complete setup of your CachyOS KDE Plasma system with all your custom configurations, applications, and desktop layout.

## � Repository Differences

**This is the COMPLETE Post-Install repository** - includes everything needed for a fresh system setup.

### Post-Install-CachyOS vs CachyOS-KDE-Current:
- **Post-Install-CachyOS** (this repo): Complete toolkit with all scripts, icons, and documentation for fresh installs
  - Includes `Scripts/` folder with 31 utility scripts
  - Includes `Desktop-Icons/` folder with 25 desktop launchers
  - Includes `FIREFOX_RAM_SETUP.md` for Firefox optimization
  - Complete System Control Panel implementation
  - Ready for new system deployment

- **CachyOS-KDE-Current**: Current working KDE configuration snapshot
  - Streamlined for active system state
  - Core setup files only
  - Focused on KDE Plasma configuration
  - No extra scripts/icons folders

**Use this repository when**: Setting up a new CachyOS system or need complete scripts/icons collection.

## �📁 Files Overview

### 📋 Documentation
- `CACHYOS_GLOBAL_SETTINGS.md` - Complete system configuration documentation
- `KWALLET_WINDSURF_FIX.md` - KWallet auto-unlock fix for Windsurf and other applications
- `TERMINAL_TOOLS_SETUP.md` - Oh My Zsh, Powerlevel10k, Fresh Editor, Yazi, and Tmux setup
- `Terminal-ASCII-Programs.md` - ASCII art entertainment programs (unimatrix with Japanese katakana, asciiquarium, bonsai.sh)
- `SYSTEM_CONTROL_ICONS_COMPLETE.md` - Complete Power Off, Reboot, Full Shutdown, and Logout icons with Firefox integration
- `WINDOWS_DUAL_BOOT_SETUP.md` - Windows dual-boot setup for GRUB and drive mounting
- `YAKUAKE_SETUP.md` - Yakuake startup configuration with tabs
- `XSCREENSAVER_SETUP_GUIDE.md` - Complete XScreenSaver installation and configuration for Wayland
- `KDE_WINDOW_POSITION_SAVING.md` - Guide for automatic window position saving in KDE Plasma
- `AUTOLOGIN_AUTOLOCK_SETUP.md` - Auto-login with immediate screen lock configuration
- `1st-use-of-post-install.md` - Documentation of first successful post-install script execution
- `post-reinstall-session-jan12-2026.md` - Complete session log of post-reinstall fixes and configurations
- `README.md` - This file - Usage instructions and script order

### 🔧 Scripts (Use in Order)
1. `cachyos-kde-post-install.sh` - Basic KDE Plasma configuration
2. `discover-system-config.sh` - System discovery (for reference/backup)
3. `cachyos-comprehensive-post-install.sh` - Complete system setup

### 🔧 Configuration Backups
- `fstab.backup` - Current system fstab configuration backup
- `grub.cfg.backup` - Current GRUB bootloader configuration backup

## 🚀 Usage Order

### Step 1: Basic KDE Configuration (Optional)
**Script**: `cachyos-kde-post-install.sh`

**When to use**: 
- Fresh CachyOS install with KDE Plasma
- Want basic theme and effects setup only
- Quick KDE configuration without additional applications

**What it does**:
- Sets KDE-Story-Dark-Global-6 theme
- Configures window decorations and desktop effects
- Applies basic KDE settings
- ~80% automated, requires manual steps for transparency and effects

**Run**:
```bash
./cachyos-kde-post-install.sh
```

---

### Step 2: System Discovery (Reference Only)
**Script**: `discover-system-config.sh`

**When to use**:
- Before creating custom post-install scripts
- Want to backup current system configuration
- Need to understand system setup details

**What it does**:
- Discovers all system configurations
- Creates detailed documentation files
- Captures desktop icons, panel setup, network mounts
- Generates comprehensive configuration report

**Run**:
```bash
./discover-system-config.sh
```

**Output**: Creates `cachyos-discovery-YYYYMMDD-HHMMSS/` directory with 10+ configuration files

---

### Step 3: Pre-Reinstall Backup (Recommended)
**Script**: `pre-reinstall-backup-incremental.sh`

**When to use**:
- Before OS reinstall
- Want to save only new/changed files
- Avoid duplicating existing data on external drive

**What it does**:
- Compares files with external drive
- Only backs up missing or different files
- Excludes application settings and security data
- Massive space savings (500MB vs 124GB)

**Run**:
```bash
./pre-reinstall-backup-incremental.sh
```

**Output**: Creates `pre-reinstall-backup-YYYYMMDD-HHMMSS/` with only incremental changes

---

### Step 4: Complete System Setup (Recommended)
**Script**: `cachyos-comprehensive-post-install.sh`

**When to use**:
- Fresh CachyOS install
- Complete system recreation needed
- Want all applications, configurations, and desktop layout

**What it does**:
- Installs all applications (Steam, MAME, VLC, HandBrake, Krita, etc.)
- Configures network storage mounts (SPCC_1TB, drives)
- Sets up KDE theme and all desktop effects
- Configures panel launchers (17 + 8 items)
- Creates 40+ desktop icons and launchers
- Sets up time display (seconds + date)
- Creates custom scripts and NAS controls
- ~95% automated

**Run**:
```bash
./cachyos-comprehensive-post-install.sh
```

---

## 📋 Script Comparison

| Feature | Basic Script | Comprehensive Script | Incremental Backup |
|---------|-------------|---------------------|------------------|
| KDE Theme | ✅ | ✅ | ✅ |
| Desktop Effects | ✅ | ✅ | ✅ |
| Window Decorations | ✅ | ✅ | ✅ |
| Panel Configuration | ❌ | ✅ | ✅ |
| Desktop Icons | ❌ | ✅ | ✅ |
| Application Installation | ❌ | ✅ | ❌ |
| Network Storage | ❌ | ✅ | ❌ |
| Time Configuration | ❌ | ✅ | ✅ |
| Custom Scripts | ❌ | ✅ | ✅ |
| NAS Controls | ❌ | ✅ | ✅ |
| Automation Level | ~80% | ~95% | N/A |
| Space Usage | N/A | N/A | ~500MB vs 124GB |

## 🛠️ Prerequisites

### System Requirements:
- CachyOS with KDE Plasma
- Internet connection for package installation
- User account (not root)
- Sudo access for system packages

### Required Tools:
```bash
# Install yay for AUR packages (if not installed)
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## 📝 Manual Steps Required

After running the comprehensive script, complete these manual steps:

### 1. Transparency Settings
- **Path**: System Settings → Global Themes → Application Style → Transparency tab
- **Action**: Click edit icon (pencil) and configure transparency settings

### 2. Magic Lamp Effect
- **Path**: System Settings → Workspace → Desktop Effects → Animations
- **Action**: Change "Window Minimize" effect to "Magic Lamp"

### 3. Panel Configuration
- **Action**: Right-click panel → Configure Panel
- **Settings**: Position: Top, Width: Custom, Opacity: Translucent

### 4. FileZilla Configuration
- **Action**: Import site manager entries from backup
- **Location**: Network connections and SMB settings

### 5. NordVPN Setup
- **Action**: Configure VPN connections and credentials
- **Note**: Desktop launcher created, but requires manual login

### 6. Network Storage Testing
- **Action**: Test all network mounts and adjust if needed
- **Commands**: `mount -a` to verify fstab entries

## 🔄 Final Steps

### Recommended Reinstall Workflow:
1. **Before Reinstall**: Run `./pre-reinstall-backup-incremental.sh`
2. **Install CachyOS**: Fresh install with KDE Plasma
3. **Run Post-Install**: `./cachyos-comprehensive-post-install.sh`
4. **Restore Backup**: Copy incremental backup files as needed
5. **Manual Setup**: Configure applications and security

### Restart System:
```bash
# Reboot to ensure all changes take effect
sudo reboot
```

### Verify Configuration:
- Check desktop icons are working
- Verify panel launchers are present
- Test network storage mounts
- Confirm time display shows seconds and date
- Validate desktop effects are active

## 💾 Backup and Recovery

### Automatic Backups:
- Scripts create timestamped backups before making changes
- Location: `~/.config/kde-backup-YYYYMMDD-HHMMSS/`
- Includes: kdeglobals, kwinrc, plasmarc, plasma-appletsrc

### Manual Backup:
```bash
# Backup entire KDE configuration
cp -r ~/.config/kde* ~/kde-config-backup/
cp -r ~/.local/share/plasmashell ~/plasma-backup/
```

### Restore from Backup:
```bash
# Restore KDE configuration
cp ~/.config/kde-backup-YYYYMMDD-HHMMSS/* ~/.config/
# Restart Plasma
kquitapp6 plasmashell && plasmashell &
```

## 🐛 Troubleshooting

### Common Issues:

#### 1. Panel Configuration Not Applied
**Solution**: Restart Plasma shell
```bash
kquitapp6 plasmashell && sleep 2 && plasmashell &
```

#### 2. Desktop Icons Not Showing
**Solution**: Refresh desktop
```bash
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript \
'var allDesktops = desktops();for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.reloadConfiguration();}'
```

#### 3. Network Mounts Failed
**Solution**: Check fstab and mount manually
```bash
sudo mount -a
# Check for errors in /var/log/syslog
```

#### 4. Applications Not Installed
**Solution**: Install missing packages manually
```bash
# Update package database
sudo pacman -Sy
# Install missing packages
sudo pacman -S package-name
# For AUR packages
yay -S package-name
```

#### 5. Desktop Effects Not Working
**Solution**: Check KWin configuration and restart
```bash
# Restart KWin
kwin_x11 --replace &
# Check effects in System Settings
```

#### 6. Windsurf/Applications Can't Access OS Keyring
**Solution**: Configure KWallet auto-unlock
```bash
# See detailed fix in KWALLET_WINDSURF_FIX.md
# Quick fix: Sync kwallet password with login password
kwalletmanager
# Then: Settings → Configure KWallet → Change Password
```

## 📞 Support

### Script Issues:
1. Check script permissions: `chmod +x script-name.sh`
2. Verify running as user (not root)
3. Check system logs for errors
4. Ensure internet connection for package installation

### Configuration Issues:
1. Review generated backup files
2. Compare with `CACHYOS_GLOBAL_SETTINGS.md`
3. Use discovery script to analyze current state
4. Manual adjustment may be needed for some settings

## 📊 What Gets Configured

### System Packages:
- **Gaming**: Steam, MAME, Dolphin, RetroArch
- **Development**: Code, Kate, VirtualBox, Windsurf, Flutter
- **Media**: VLC, HandBrake, Shotcut, SoundConverter, OBS (with 5 camera scenes: Full, Right-Bottom, Right-Top, Left-Top, Left-Bottom)
- **Graphics**: Krita
- **Network**: FileZilla, Remmina, NordVPN, qBittorrent
- **System**: Octopi, Double Commander, Cool Retro Term
- **Security**: Falcon sensor

### KDE Configuration:
- **Theme**: CachyOS Nord
- **Effects**: 12 effects including Blur, Magic Lamp, Wobbly Windows
- **Window Decorations**: Custom button layout
- **Panels**: Dual panels with custom launchers
- **Time Display**: Seconds and date below time

### Terminal Autostart:
- **Yakuake**: 9 tabs on boot - shell, yazi, c (eza directory preview with alt+c), eza (ctrl+c), fresh, unimatrix (Japanese katakana Matrix effect), asciiquarium, bonsai.sh, shell
- **Konsole**: 9 tabs on boot - same as above

### Desktop Layout:
- **4 System Control Icons**: Power Off, Reboot, Full Shutdown, Logout with Firefox integration
- **40+ Icons**: Emulators, games, utilities, NAS controls
- **Custom Scripts**: Launch scripts for emulators
- **Network Storage**: Auto-mount drives and NAS
- **Panel Launchers**: 25+ total across both panels
- **App Positioning**: KDE default behavior (apps remember last position)

## 🎉 Success Criteria

Your system is successfully configured when:
- ✅ All applications are installed and launchable
- ✅ Desktop icons appear and work correctly
- ✅ System control icons (Power Off, Reboot, Full Shutdown, Logout) work properly
- ✅ Panel launchers are present and functional
- ✅ Time display shows seconds and date
- ✅ Desktop effects are active (especially Magic Lamp)
- ✅ Network storage mounts are accessible
- ✅ Theme and appearance match documentation
- ✅ Firefox RAM optimization works correctly
- ✅ Apps remember their positions (KDE default behavior)
- ✅ Custom scripts execute properly
- ✅ Terminal emulators (Yakuake and Konsole) open with 9 configured tabs on boot

---

## 📝 Recent Updates

### January 13, 2026 - Unimatrix and Japanese Fonts Integration
- **Updated**: Yakuake configuration from 7 to 9 tabs
  - Added shell tabs at beginning and end
  - Updated alt+c tab to use 'c' command (eza directory preview)
  - Updated fresh tab to use full path `/home/duck/.zshrc`
- **Replaced**: cmatrix with unimatrix for proper Japanese katakana character display
  - cmatrix `-c` flag had rendering bug (outputted spaces instead of katakana)
  - unimatrix properly displays half-width katakana (ｦ ｧ ｨ ｩ ｪ ｫ ｬ ｭ ｮ ｯ ｰ ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ)
  - Command: `unimatrix -c green`
- **Added**: Japanese fonts installation to post-install script
  - noto-fonts-cjk, ttf-hanazono, adobe-source-han-sans-jp-fonts, ttf-sazanami
- **Added**: Japanese locale generation (ja_JP.UTF-8)
- **Updated**: `cachyos-comprehensive-post-install.sh` with all changes
- **Updated**: `YAKUAKE_SETUP.md` with unimatrix configuration and installation instructions
- **Created**: Backup of Yakuake configuration (`~/backups/yakuake_20260113_082640.tar.gz`)

### January 12, 2026 - Post-Reinstall Session (Evening Update)
- **Added**: Auto-login with immediate screen lock configuration
  - SDDM auto-login enabled for user `duck`
  - KDE autostart locks screen 5 seconds after login
  - Lock screen displays custom MtFuji.png wallpaper
  - `AUTOLOGIN_AUTOLOCK_SETUP.md` - Complete setup guide
- **Fixed**: KWallet service configuration for Windsurf

### January 12, 2026 - Post-Reinstall Session (Morning)
- **Fixed**: Yakuake autostart configuration (absolute path required)
- **Fixed**: Windsurf application icon in launcher
- **Fixed**: Desktop icons - centralized to `~/.local/share/icons/`
- **Fixed**: Handbrake executable path and icon
- **Fixed**: Lock screen image persistence across reboots
- **Fixed**: SDDM login screen theme (KDE-Story-Dark-SDDM-6) with custom background
- **Added**: NordVPN CLI and GUI installation
- **Added**: Window position saving with KWin script "Remember Window Positions"
- **Added**: GRUB os-prober configuration for Windows 11 dual-boot
- **Added**: Comprehensive documentation files:
  - `post-reinstall-session-jan12-2026.md` - Complete session log
  - `KDE_WINDOW_POSITION_SAVING.md` - Window position saving guide
  - `1st-use-of-post-install.md` - First use documentation
- **Fixed**: Git repository cleanup with `.gitignore` for Windsurf performance

### January 1, 2026 - Initial Creation
- Created comprehensive post-install script collection
- Documented complete system setup process
- Added all configuration documentation files

---

**Created**: January 1, 2026  
**Last Updated**: January 12, 2026  
**Compatible**: CachyOS with KDE Plasma  
**Maintenance**: Update scripts when system configuration changes
