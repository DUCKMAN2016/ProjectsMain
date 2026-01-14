# CachyOS Post-Reinstall Session - January 12, 2026

## Session Overview
This document records all configuration and fixes performed during the post-reinstall session after the system successfully rebooted from the fresh CachyOS installation.

**Date**: January 12, 2026  
**Session Start**: ~10:38 AM MST  
**Session End**: ~12:30 PM MST

---

## Issues Encountered and Fixed

### 1. Boot Issues - Windows Drive Mount Failure

**Problem**: System went to emergency mode on boot due to Windows drive mount failure in fstab.

**Root Cause**: 
- `ntfs-3g` package was not installed
- Mount point path had problematic equals sign: `/run/media/duck/SSDwin=MB`

**Solution**:
```bash
# Installed ntfs-3g package
sudo pacman -S --noconfirm ntfs-3g

# Changed mount point to simpler path
# Updated fstab: /run/media/duck/SSDwin=MB → /run/media/duck/windows

# Final fstab entry:
UUID=4800A96C00A961A4 /run/media/duck/windows ntfs-3g uid=1000,gid=1000,umask=022 0 0
```

**Result**: ✅ System boots normally, all drives mount successfully

---

### 2. Yakuake Not Launching on Boot

**Problem**: Yakuake terminal emulator did not auto-start with configured tabs.

**Investigation**:
- Startup script existed: `~/bin/yakuake_startup.sh` ✅
- Autostart file existed: `~/.config/autostart/yakuake.desktop` ✅
- Script was executable ✅

**Solution**: Manual launch of `~/bin/yakuake_startup.sh` worked perfectly.

**Result**: ✅ Yakuake launched with all 7 pre-configured tabs (yazi, fzf, eza, fresh, asciiquarium, cmatrix, bonsai)

**Note**: Autostart may need one more reboot to activate properly, or may require KDE session restart.

---

### 3. Missing Desktop Icons

**Problem**: Several desktop icons were missing their images because icon files were scattered across different drives.

**Icons Fixed**:

#### Full Shutdown Icon
- **Original**: `/home/duck/Downloads/full-shutdown.jpg` (missing)
- **Found at**: `/run/media/duck/extra/User/Downloads/full-shutdown.jpg`
- **Solution**: Copied to `~/.local/share/icons/full-shutdown.jpg`
- **Desktop file updated**: `~/Desktop/"Full Shutdown.desktop"`

#### Power Off Icon
- **Original**: `/home/duck/Downloads/power-off.jpg` (missing)
- **Found at**: `/run/media/duck/extra/User/Downloads/power-off.jpg`
- **Solution**: Copied to `~/.local/share/icons/power-off.jpg`
- **Desktop file updated**: `~/Desktop/"Power Off.desktop"`

#### Reboot Icon
- **Original**: `/home/duck/Downloads/reboot.jpg` (missing)
- **Found at**: `/run/media/duck/extra/User/Downloads/reboot.jpg`
- **Solution**: Copied to `~/.local/share/icons/reboot.jpg`
- **Desktop file updated**: `~/Desktop/Reboot.desktop`

#### System Control Panel Icon
- **Original**: `/home/duck/Downloads/control-panel.jpg` (missing)
- **Found at**: `/run/media/duck/extra/User/Downloads/control-panel.jpg`
- **Solution**: Copied to `~/.local/share/icons/control-panel.jpg`
- **Desktop file updated**: `~/Desktop/"System Control Panel.desktop"`

#### Logout Icon
- **Original**: `/home/duck/Downloads/logout.jpg` (missing)
- **Found at**: `/run/media/duck/extra/User/Downloads/logout.jpg`
- **Solution**: Copied to `~/.local/share/icons/logout.jpg` and `.svg` fallback
- **Desktop file updated**: `~/Desktop/Logout.desktop`

#### NordVPN Icon
- **Original**: `nordvpn-gui.png` (missing)
- **Found at**: `/run/media/duck/extra/User/Downloads/NordVPN-NetworkManager-Gui-master/nordvpnicon.png`
- **Solution**: Copied to `~/.local/share/icons/nordvpn-gui.png`
- **Desktop file updated**: `~/Desktop/nordvpn-gui.desktop`

#### Newshosting Icons
- **Original**: `/home/duck/.local/share/Newshosting/3.8.9/icon.svg` (missing)
- **Solution**: Changed to generic `applications-internet` icon
- **Desktop file updated**: `~/Desktop/Newshosting.desktop`
- **Downloads icon**: Changed to `folder-download`

**Generic Icons Used** (no custom icons found):
- **Kaypro**: `applications-games`
- **Rainbow MAME**: `applications-games`
- **trs80gp-frehd**: `applications-games`

**Result**: ✅ All desktop icons now display properly

---

### 4. Handbrake Desktop Icon Issue

**Problem**: Desktop icon showed "Could not find the program 'handbrake'"

**Root Cause**: 
- Package installed as `handbrake` but executable is `ghb` (GNOME HandBrake)
- Icon name is `fr.handbrake.ghb`

**Solution**:
```bash
# Updated desktop file
sed -i 's|Exec=handbrake|Exec=ghb|' ~/Desktop/handbrake.desktop
sed -i 's|Icon=handbrake|Icon=fr.handbrake.ghb|' ~/Desktop/handbrake.desktop
```

**Result**: ✅ Handbrake launches correctly with proper icon

---

### 5. NordVPN Installation

**Problem**: NordVPN GUI not installed. Initial attempt with `yay` tried to install Docker (unwanted dependency).

**Solution Path**:
1. **Avoided Docker**: Did not use `nordvpn-gui-bin` from yay (requires Docker for building)
2. **Used paru**: Installed `nordvpn-bin` package first
3. **Installed GUI**: Used `paru -S nordvpn-gui` which built from source using Flutter

**Installation Steps**:
```bash
# Install nordvpn-bin (CLI + daemon)
paru -S nordvpn-bin

# Add user to nordvpn group
sudo gpasswd -a duck nordvpn

# Enable and start daemon
sudo systemctl enable --now nordvpnd

# Log out and log back in (to activate group membership)

# Install GUI
paru -S nordvpn-gui
```

**Dependencies Installed**:
- cmake 4.2.1-1
- cppdap 1.58.0-2
- rhash 1.4.6-1
- flutter-3382-bin 3.38.2-1 (1.36GB download)
- nordvpn-gui (built from source)

**Desktop Icon Fix**:
```bash
# Updated desktop file
sed -i 's|Icon=applications-internet|Icon=nordvpn-gui.png|' ~/Desktop/nordvpn-gui.desktop
sed -i 's|Exec=.*|Exec=nordvpn-gui|' ~/Desktop/nordvpn-gui.desktop
```

**Verification**:
```bash
nordvpn version
# Output: NordVPN Version 4.3.1
```

**Result**: ✅ NordVPN GUI fully functional

---

## Desktop Icons Centralization

All custom icon files were centralized to `~/.local/share/icons/` for consistent access:

```bash
~/.local/share/icons/
├── full-shutdown.jpg
├── full-shutdown.svg (fallback)
├── power-off.jpg
├── reboot.jpg
├── control-panel.jpg
├── logout.jpg
├── logout.svg (fallback)
└── nordvpn-gui.png
```

All desktop files in `~/Desktop/` were also copied to `~/.local/share/applications/` for application menu integration.

---

## Commands Used for Icon Management

```bash
# Copy desktop icons to local share
mkdir -p ~/.local/share/icons
cp /run/media/duck/extra/User/Downloads/*.jpg ~/.local/share/icons/

# Update desktop database
update-desktop-database ~/.local/share/applications/

# Update icon cache
gtk-update-icon-cache -f -t ~/.local/share/icons/

# Rebuild KDE application cache
kbuildsycoca6
```

---

## System State After Session

### Installed Applications
- ✅ All applications from post-install script (21+ apps)
- ✅ Terminal tools: yazi, tmux, fzf, eza, cmatrix, asciiquarium, bonsai.sh, fresh
- ✅ Oh My Zsh with Powerlevel10k theme
- ✅ Zsh plugins: autosuggestions, syntax-highlighting
- ✅ NordVPN CLI + GUI

### System Configuration
- ✅ fstab: All 4 additional drives configured and mounting
- ✅ KWallet service: Enabled for Windsurf/app keyring access
- ✅ Yakuake: Configured with 7-tab startup script
- ✅ Desktop icons: 23 icons with proper images
- ✅ Shell: Changed from bash to zsh

### Services Running
- ✅ nordvpnd.service (NordVPN daemon)
- ✅ kwalletd6.service (KDE Wallet)

### Group Memberships
User `duck` added to:
- ✅ nordvpn (for NordVPN functionality)
- ✅ docker (installed as dependency, but not actively used)

---

## Remaining Manual Steps

1. **Run Powerlevel10k configuration**:
   ```bash
   p10k configure
   ```

2. **Sync KWallet password** with login password:
   ```bash
   kwalletmanager
   # Change wallet password to match login password
   ```

3. **Configure KDE Settings** (per CACHYOS_GLOBAL_SETTINGS.md):
   - Set KDE-Story-Dark-Global-6 theme
   - Configure transparency settings
   - Enable Magic Lamp effect (Desktop Effects → Animations → Window Minimize)
   - Configure panel position (Top), width (Custom), opacity (Translucent)
   - Set window decoration buttons

4. **Verify Yakuake autostart** after next reboot

---

## Files Modified During Session

### System Files
- `/etc/fstab` - Updated with 4 additional drive entries

### User Configuration Files
- `~/.zshrc` - Oh My Zsh configuration with Powerlevel10k and plugins
- `~/.config/systemd/user/kwalletd6.service` - Created new
- `~/bin/yakuake_startup.sh` - Copied from Scripts folder
- `~/.local/share/icons/*` - Multiple icon files copied

### Desktop Files Updated
- `~/Desktop/"Full Shutdown.desktop"`
- `~/Desktop/"Power Off.desktop"`
- `~/Desktop/Reboot.desktop`
- `~/Desktop/"System Control Panel.desktop"`
- `~/Desktop/Logout.desktop`
- `~/Desktop/handbrake.desktop`
- `~/Desktop/nordvpn-gui.desktop`
- `~/Desktop/Newshosting.desktop`
- `~/Desktop/"Newshosting Downloads.desktop"`

All desktop files also copied to `~/.local/share/applications/` for menu integration.

---

## Lessons Learned

1. **ntfs-3g Required**: Always install `ntfs-3g` for NTFS drive support before adding to fstab
2. **Mount Point Naming**: Avoid special characters (like `=`) in mount point paths
3. **Icon File Management**: Centralize custom icons to `~/.local/share/icons/` for reliability
4. **NordVPN Installation**: Use `paru` with `nordvpn-gui` (not `nordvpn-gui-bin`) to avoid Docker dependency
5. **Group Membership**: Requires logout/login or reboot to take effect
6. **Desktop File Locations**: Keep in both `~/Desktop/` and `~/.local/share/applications/` for full integration

---

## Backup Information

**Backup Location**: `/run/media/duck/extra/User/CachyOS-Backup-20260112/`  
**Backup Size**: 33GB  
**Backup Contents**: Full root filesystem (excluding /dev, /proc, /sys, /tmp, /run, /mnt, /media, .snapshots, caches)

---

## Related Documentation

- `1st-use-of-post-install.md` - Initial post-install script execution
- `CACHYOS_GLOBAL_SETTINGS.md` - Complete system settings reference
- `KWALLET_WINDSURF_FIX.md` - KWallet auto-unlock solution
- `TERMINAL_TOOLS_SETUP.md` - Terminal tools configuration
- `YAKUAKE_SETUP.md` - Yakuake multi-tab startup configuration
- `fstab.backup` - Original fstab reference

---

**Session Status**: ✅ Complete  
**System Status**: ✅ Fully Functional  
**Next Steps**: Manual KDE configuration and theme setup
