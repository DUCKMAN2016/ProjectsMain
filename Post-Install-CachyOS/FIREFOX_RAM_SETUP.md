# Firefox in RAM Setup Guide

## Overview
Running Firefox directly in RAM provides significant performance improvements by moving the browser profile to `/dev/shm`, a memory-backed filesystem. This optimization delivers:

- **Blazing speed** - All browser operations run at RAM speed
- **Reduced SSD wear** - No constant disk writes during browsing
- **Smoother scrolling** - Lower latency for all operations
- **Persistent data** - Automatic sync between RAM and disk on boot/shutdown

## System Requirements
- **RAM**: Minimum 8GB recommended (16GB+ ideal)
- **Profile size**: Typically 200-500MB
- **Init system**: systemd (standard on CachyOS/Arch)

## Current Setup Details

### Profile Information
- **Profile name**: `jkfujx2p.default-release`
- **Profile size**: 251MB
- **RAM location**: `/dev/shm/firefox-profile`
- **Backup location**: `~/.mozilla/firefox/jkfujx2p.default-release.backup`

### System RAM Status
```
Total RAM: 31GB
Available: 21GB
Profile usage: 251MB (~0.8% of total RAM)
```

## Installation Steps

### 1. Identify Firefox Profile
```bash
ls ~/.mozilla/firefox
cat ~/.mozilla/firefox/profiles.ini
```

### 2. Close Firefox
```bash
# Check if Firefox is running
pgrep -l firefox

# Close Firefox before proceeding
```

### 3. Create RAM Directory
```bash
mkdir -p /dev/shm/firefox-profile
```

### 4. Copy Profile to RAM
```bash
# Replace YOUR_PROFILE with your actual profile name
cp -a ~/.mozilla/firefox/YOUR_PROFILE/* /dev/shm/firefox-profile/
```

### 5. Create Backup and Symlink
```bash
# Rename original as backup
mv ~/.mozilla/firefox/YOUR_PROFILE ~/.mozilla/firefox/YOUR_PROFILE.backup

# Create symbolic link
ln -s /dev/shm/firefox-profile ~/.mozilla/firefox/YOUR_PROFILE
```

### 6. Create Save Script
```bash
sudo nano /usr/local/bin/save-firefox-profile.sh
```

Content:
```bash
#!/bin/sh
rsync -a --delete /dev/shm/firefox-profile/ /home/duck/.mozilla/firefox/jkfujx2p.default-release.backup/
```

### 7. Create Restore Script
```bash
sudo nano /usr/local/bin/restore-firefox-profile.sh
```

Content:
```bash
#!/bin/sh
mkdir -p /dev/shm/firefox-profile
rsync -a /home/duck/.mozilla/firefox/jkfujx2p.default-release.backup/ /dev/shm/firefox-profile/
```

### 8. Make Scripts Executable
```bash
sudo chmod +x /usr/local/bin/save-firefox-profile.sh
sudo chmod +x /usr/local/bin/restore-firefox-profile.sh
```

### 9. Create systemd Restore Service
```bash
sudo nano /etc/systemd/system/firefox-restore.service
```

Content:
```ini
[Unit]
Description=Restore Firefox RAM profile
Before=graphical.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/restore-firefox-profile.sh

[Install]
WantedBy=graphical.target
```

### 10. Create systemd Save Service
```bash
sudo nano /etc/systemd/system/firefox-save.service
```

Content:
```ini
[Unit]
Description=Save Firefox RAM profile back to disk
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/save-firefox-profile.sh

[Install]
WantedBy=shutdown.target
```

### 11. Enable Services
```bash
sudo systemctl enable firefox-restore.service
sudo systemctl enable firefox-save.service
```

## Quick Installation Commands

For quick setup, run these commands in sequence:

```bash
# Copy scripts to system
sudo cp /tmp/save-firefox-profile.sh /usr/local/bin/save-firefox-profile.sh
sudo cp /tmp/restore-firefox-profile.sh /usr/local/bin/restore-firefox-profile.sh
sudo chmod +x /usr/local/bin/save-firefox-profile.sh /usr/local/bin/restore-firefox-profile.sh

# Install systemd services
sudo cp /tmp/firefox-restore.service /etc/systemd/system/firefox-restore.service
sudo cp /tmp/firefox-save.service /etc/systemd/system/firefox-save.service

# Enable services
sudo systemctl enable firefox-restore.service
sudo systemctl enable firefox-save.service
```

## How It Works

### On System Boot
1. `firefox-restore.service` runs before the graphical environment loads
2. Script copies profile from disk backup to `/dev/shm/firefox-profile`
3. Firefox launches and uses the RAM-based profile via symlink

### During Use
- All Firefox operations (browsing, downloads, cache) run in RAM
- No disk writes occur during normal browsing
- Profile remains in RAM until shutdown

### On System Shutdown
1. `firefox-save.service` runs before shutdown
2. Script syncs all changes from RAM back to disk backup
3. Data is preserved for next boot

## Verification

### Check Symlink
```bash
ls -la ~/.mozilla/firefox/ | grep jkfujx2p
```
Should show: `jkfujx2p.default-release -> /dev/shm/firefox-profile`

### Check RAM Usage
```bash
du -sh /dev/shm/firefox-profile
```

### Check Services Status
```bash
systemctl status firefox-restore.service
systemctl status firefox-save.service
```

### Test Firefox
1. Launch Firefox
2. Browse normally
3. Check that profile is in RAM: `ls -la ~/.mozilla/firefox/`

## Manual Backup

To manually save your current session:
```bash
/usr/local/bin/save-firefox-profile.sh
```

To manually restore from backup:
```bash
/usr/local/bin/restore-firefox-profile.sh
```

## Troubleshooting

### Firefox Won't Start
1. Check symlink: `ls -la ~/.mozilla/firefox/jkfujx2p.default-release`
2. Verify RAM directory exists: `ls -la /dev/shm/firefox-profile`
3. Restore from backup: `/usr/local/bin/restore-firefox-profile.sh`

### Profile Not Saving
1. Check service status: `systemctl status firefox-save.service`
2. Manually run save script: `sudo /usr/local/bin/save-firefox-profile.sh`
3. Check logs: `journalctl -u firefox-save.service`

### Out of RAM
- Monitor usage: `free -h`
- Profile size: `du -sh /dev/shm/firefox-profile`
- If needed, clear Firefox cache or reduce extensions

## Benefits Observed

- **Startup time**: Significantly faster Firefox launch
- **Tab loading**: Near-instant page loads from cache
- **Scrolling**: Smoother, more responsive
- **Extensions**: Faster extension operations
- **SSD lifespan**: Reduced write cycles

## Important Notes

⚠️ **Data Safety**
- Profile is saved on shutdown via systemd service
- Manual saves recommended before system updates
- Keep backup directory intact: `~/.mozilla/firefox/jkfujx2p.default-release.backup`

⚠️ **RAM Considerations**
- `/dev/shm` is cleared on reboot (data restored from backup)
- Ensure adequate RAM for profile + system operations
- Monitor RAM usage if running memory-intensive applications

⚠️ **Power Loss**
- Unexpected shutdown may lose unsaved profile changes
- Consider periodic manual saves during long sessions
- Use UPS for critical systems

## References

- Original guide: https://youtux.org/Put%20Your%20Browser%20in%20RAM.html
- Setup date: January 10, 2026
- System: CachyOS (Arch Linux)
- Profile: jkfujx2p.default-release (251MB)

## Chromium-based Browsers

This setup can be adapted for Chrome/Chromium/Brave:
- Profile location: `~/.config/google-chrome` or `~/.config/chromium`
- Same process: copy to RAM, create symlink, setup scripts
- Adjust paths in scripts accordingly
