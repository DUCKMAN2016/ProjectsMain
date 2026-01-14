# First Use of Post-Install Scripts - January 12, 2026

This document records the first successful use of the CachyOS post-install scripts after a fresh reinstall.

## Context

- **Date**: January 12, 2026
- **Reason for Reinstall**: Drive issue requiring fresh CachyOS installation
- **Previous System**: CachyOS with KDE Plasma (backed up before reinstall)

## Pre-Reinstall Backup Created

- **Location**: `/run/media/duck/extra/User/CachyOS-Backup-20260112/`
- **Size**: 33GB
- **Contents**: Full root filesystem backup
- **Exclusions**: /dev, /proc, /sys, /tmp, /run, /mnt, /media, .snapshots, pacman cache, user cache

## Applications Installed

### From Official Repositories (pacman)
- **Gaming**: Steam, MAME, Dolphin-emu, RetroArch
- **Development**: Code (VS Code), Kate
- **Media**: VLC, HandBrake, Krita, OBS Studio, Shotcut, SoundConverter
- **Network**: FileZilla, Remmina, qBittorrent
- **Utilities**: Double Commander, Cool Retro Term, XScreenSaver, Konsole
- **Terminal Tools**: yazi, tmux, fzf, eza, cmatrix, asciiquarium

### From AUR (yay/paru)
- **Windsurf** - AI-powered development environment
- **Enpass** - Password manager (enpass-bin)
- **bonsai.sh** - ASCII tree animation
- **fresh-editor-bin** - Terminal text editor

## Terminal Configuration

### Oh My Zsh
- **Status**: Installed
- **Theme**: Powerlevel10k
- **Plugins**: 
  - git (default)
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- **Custom Alias**: `cls` → `clear`

### Shell Changed
- Default shell changed from bash to zsh
- Zsh configuration at `~/.zshrc`

## System Configuration

### fstab Updated
Added entries for additional drives:
```
# SPCC_1TB
UUID=5907bd8b-2224-427d-a594-a9d87ce5954a /run/media/duck/SPCC_1TB ext4 defaults,noatime 0 2

# Windows drive
UUID=4800A96C00A961A4 /run/media/duck/SSDwin=MB ntfs-3g uid=1000,gid=1000,umask=022 0 0

# Kubuntu data drive
UUID=c0e4bdd3-ccf0-4a7d-960f-daf2ba52984e /run/media/duck/ku ext4 defaults,noatime 0 2

# Extra drive
UUID=f8ff17ec-5808-4c21-a9f1-819ffb59c49c /run/media/duck/extra ext4 defaults,noatime 0 2
```

### KWallet Service
- Created systemd user service at `~/.config/systemd/user/kwalletd6.service`
- Service enabled for auto-start
- Required for Windsurf and other apps to access OS keyring

### Yakuake Startup
- Startup script copied to `~/bin/yakuake_startup.sh`
- Autostart desktop file configured at `~/.config/autostart/yakuake.desktop`
- Configured for 7 tabs on boot (yazi, fzf, eza, fresh, asciiquarium, cmatrix, bonsai)

### Desktop Icons
- 23 desktop icons copied from `Desktop-Icons/` folder
- Includes: Power Off, Reboot, Full Shutdown, Logout, System Control Panel
- Emulator launchers: Rainbow MAME, Kaypro
- Application shortcuts: Steam, qBittorrent, Octopi, NordVPN, etc.

## Script Fix Applied

Fixed stray text in `cachyos-comprehensive-post-install.sh` line 1:
- **Before**: `doesn't seem like the find tool is even searching#!/bin/bash`
- **After**: `#!/bin/bash`

## Manual Steps Completed After Script

1. ✅ Mounted Windows drive manually (was not auto-mounting initially)
2. ✅ Installed yay AUR helper
3. ✅ Installed Enpass password manager

## Manual Steps Still Required

1. **Reboot** - Apply all system changes
2. **Run `p10k configure`** - Configure Powerlevel10k theme appearance
3. **Sync KWallet password** - Run `kwalletmanager` and change password to match login password
4. **KDE Settings** (per CACHYOS_GLOBAL_SETTINGS.md):
   - Set KDE-Story-Dark-Global-6 theme
   - Configure transparency settings
   - Enable Magic Lamp effect (Desktop Effects → Animations → Window Minimize)
   - Configure panel position (Top), width (Custom), opacity (Translucent)
   - Set window decoration buttons

## Lessons Learned

1. **Backup first** - Always create a full system backup before running post-install scripts
2. **Check script integrity** - Verify scripts don't have stray text or corruption
3. **fstab UUIDs** - Verify UUIDs match current drives with `lsblk -f` before updating fstab
4. **AUR helpers** - yay and paru both work; yay was installed fresh this session
5. **Terminal tools** - Some tools (yazi, tmux) are in official repos, others (bonsai.sh, fresh) require AUR

## Files Modified

- `/etc/fstab` - Added 4 drive entries
- `~/.zshrc` - Oh My Zsh configuration with Powerlevel10k and plugins
- `~/.config/systemd/user/kwalletd6.service` - Created new
- `~/.config/autostart/yakuake.desktop` - Already existed, verified correct
- `~/bin/yakuake_startup.sh` - Copied from Scripts folder
- `~/Desktop/*.desktop` - 23 desktop launchers copied

## Verification Commands

```bash
# Check installed applications
which steam mame dolphin-emu vlc handbrake krita obs yazi tmux

# Check Oh My Zsh
test -d ~/.oh-my-zsh && echo "Installed"

# Check Powerlevel10k
test -d ~/.oh-my-zsh/custom/themes/powerlevel10k && echo "Installed"

# Check KWallet service
systemctl --user is-enabled kwalletd6.service

# Check fstab
cat /etc/fstab

# Check desktop icons
ls ~/Desktop/*.desktop | wc -l
```

## Next Steps

1. Reboot system
2. Configure Powerlevel10k theme
3. Test all desktop icons
4. Verify network mounts work
5. Configure KDE appearance settings
6. Test Windsurf with KWallet integration

---

**Created**: January 12, 2026
**Purpose**: Document first successful use of post-install scripts
**Status**: ✅ Complete - Ready for reboot
