# Current KDE Plasma Wallpaper Setup

## Available Images in Wallpapers Folder (`/home/duck/Pictures/wallpapers/`)`
- It-Pc.png (3.9 MB)
- MtFuji.png (582 KB)
- edex-ui.webp (130 KB)

## Desktop Wallpapers
- **Left Monitor (Screen 0)**: MtFuji.png
- **Right Monitor (Screen 1)**: It-Pc.png
- **Location**: `/home/duck/Pictures/wallpapers/`

## Lock Screen Wallpaper
- **Image**: edex-ui.webp
- **Location**: `/home/duck/Pictures/wallpapers/edex-ui.webp`

## Configuration Files
- **Desktop Config**: `~/.config/plasma-org.kde.plasma.desktop-appletsrc`
- **Lock Screen Config**: `~/.config/kscreenlockerrc`

## Backup
Current wallpapers and configs are backed up in `/home/duck/Pictures/wallpapers_backup/`

## Restoration Commands (KDE Plasma 6)
To manually restore:

### Desktop Wallpapers
```bash
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'd = desktops()[0]; d.wallpaperPlugin = "org.kde.image"; d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"]; d.writeConfig("Image", "file:///home/duck/Pictures/wallpapers/MtFuji.png");'
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'd = desktops()[1]; d.wallpaperPlugin = "org.kde.image"; d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"]; d.writeConfig("Image", "file:///home/duck/Pictures/wallpapers/It-Pc.png");'
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell
```

### Lock Screen
```bash
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/duck/Pictures/wallpapers/edex-ui.webp"
```

## Notes
- Previous configurations are backed up in `/home/duck/Downloads/ProjectsMain/KDE-CachyOS/`
- System wallpapers are in `/usr/share/wallpapers/cachyos-wallpapers/`
- For full restoration, copy files from backup and use the commands above.
