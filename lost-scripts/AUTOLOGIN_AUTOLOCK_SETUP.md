# Auto-Login with Auto-Lock Setup for CachyOS KDE

## Overview
This guide configures CachyOS KDE to auto-login on boot and immediately lock the screen, requiring password entry. This provides convenience (no login screen) while maintaining security (locked screen with custom wallpaper).

## Configuration Summary

### 1. SDDM Auto-Login
**File**: `/etc/sddm.conf.d/kde_settings.conf`

```ini
[Autologin]
Relogin=false
Session=plasma
User=duck

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=KDE-Story-Dark-SDDM-6

[Users]
MaximumUid=60000
MinimumUid=1000
```

### 2. Auto-Lock After Login
**File**: `~/.config/autostart/autolock.desktop`

```ini
[Desktop Entry]
Type=Application
Name=Auto Lock Screen
Exec=/bin/bash -c 'sleep 5 && loginctl lock-session'
Terminal=false
X-KDE-autostart-after=panel
```

**Key Points**:
- Uses `loginctl lock-session` (works on Wayland)
- 5-second delay allows desktop to fully load
- `X-KDE-autostart-after=panel` ensures it runs after KDE panel loads

### 3. Lock Screen Wallpaper
**File**: `~/.config/kscreenlockerrc`

```ini
[Greeter]
WallpaperPlugin=org.kde.image

[Greeter][Wallpaper][org.kde.image][General]
FillMode=2
Image=file:///home/duck/Pictures/MtFuji.png
PreviewImage=/home/duck/Pictures/MtFuji.png
```

**Set via command**:
```bash
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/duck/Pictures/MtFuji.png"
```

### 4. Disable KDE Auto-Lock (Prevent Conflicts)
Go to **System Settings → Workspace Behavior → Screen Locking → Configure**:
- Set "Lock screen automatically after" to **Never**

## Installation Steps

### Step 1: Enable SDDM Auto-Login
```bash
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/kde_settings.conf << 'EOF'
[Autologin]
Relogin=false
Session=plasma
User=duck

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=KDE-Story-Dark-SDDM-6

[Users]
MaximumUid=60000
MinimumUid=1000
EOF
```

### Step 2: Create Auto-Lock Autostart
```bash
cat > ~/.config/autostart/autolock.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Auto Lock Screen
Exec=/bin/bash -c 'sleep 5 && loginctl lock-session'
Terminal=false
X-KDE-autostart-after=panel
EOF
```

### Step 3: Set Lock Screen Wallpaper
```bash
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/duck/Pictures/MtFuji.png"
```

### Step 4: Disable KDE Auto-Lock
1. Open System Settings
2. Navigate to Workspace Behavior → Screen Locking
3. Set "Lock screen automatically after" to Never

### Step 5: Reboot and Test
```bash
sudo reboot
```

## Troubleshooting

### Auto-Lock Not Working
1. Check if autostart file exists:
   ```bash
   cat ~/.config/autostart/autolock.desktop
   ```

2. Test lock command manually:
   ```bash
   loginctl lock-session
   ```

3. Check if `qdbus` is available (alternative command):
   ```bash
   which qdbus || echo "qdbus not found, use loginctl"
   ```

### Lock Screen Shows Wrong Image
1. Verify kscreenlockerrc settings:
   ```bash
   cat ~/.config/kscreenlockerrc
   ```

2. Re-apply wallpaper:
   ```bash
   kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/duck/Pictures/MtFuji.png"
   ```

### Methods That Did NOT Work
The following methods were tested and did not work reliably:

1. **Systemd system timer** (`/etc/systemd/system/autolock@.timer`) - Timer triggered but lock command failed
2. **Systemd user timer** (`~/.config/systemd/user/autolock.timer`) - Same issue
3. **KDE autostart-scripts** (`~/.config/autostart-scripts/autolock.sh`) - Script not executed
4. **qdbus command** - Not available on this system

### Working Solution
**KDE autostart .desktop file** with `loginctl lock-session` and `X-KDE-autostart-after=panel` is the reliable method.

## Desktop Lock Icon (Optional)
Create a desktop shortcut for manual locking:

**File**: `~/Desktop/Lock Screen.desktop`
```ini
[Desktop Entry]
Type=Application
Name=Lock Screen
Exec=loginctl lock-session
Icon=system-lock-screen
Terminal=false
```

## Security Notes
- Auto-login bypasses SDDM login screen but immediately locks
- Lock screen requires user password to unlock
- Custom wallpaper (MtFuji.png) displays on lock screen
- This setup is ideal for single-user systems where boot convenience is desired

---

**Created**: January 12, 2026  
**Tested On**: CachyOS KDE Plasma 6 (Wayland)  
**Status**: ✅ Verified Working
