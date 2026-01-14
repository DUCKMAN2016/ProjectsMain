#!/bin/bash

# CachyOS Pre-Reinstall Backup Script
# Backs up all critical configurations and data before OS reinstall

echo "🔄 Starting CachyOS Pre-Reinstall Backup..."

# Create backup directory with timestamp
BACKUP_DIR="/run/media/duck/extra/User/pre-reinstall-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📁 Backup directory: $BACKUP_DIR"

# ============================================================================
# 1. KDE/PLASMA CONFIGURATION
# ============================================================================
echo "🎨 Backing up KDE/Plasma configuration..."

mkdir -p "$BACKUP_DIR/kde-config"
cp -r ~/.config/kde* "$BACKUP_DIR/kde-config/" 2>/dev/null
cp -r ~/.config/plasma* "$BACKUP_DIR/kde-config/" 2>/dev/null
cp ~/.config/kdeglobals ~/.config/kwinrc ~/.config/plasmarc "$BACKUP_DIR/kde-config/" 2>/dev/null

# ============================================================================
# 2. APPLICATION CONFIGURATIONS
# ============================================================================
echo "📱 Backing up application configurations..."

mkdir -p "$BACKUP_DIR/app-configs"
cp -r ~/.config/filezilla "$BACKUP_DIR/app-configs/" 2>/dev/null
cp -r ~/.config/nordvpn* "$BACKUP_DIR/app-configs/" 2>/dev/null
cp -r ~/.config/brave "$BACKUP_DIR/app-configs/" 2>/dev/null
cp -r ~/.config/Code "$BACKUP_DIR/app-configs/" 2>/dev/null
cp -r ~/.vscode "$BACKUP_DIR/app-configs/" 2>/dev/null
cp -r ~/.config/Windsurf "$BACKUP_DIR/app-configs/" 2>/dev/null

# ============================================================================
# 3. DESKTOP AND LAUNCHERS
# ============================================================================
echo "🖥️ Backing up desktop and launchers..."

mkdir -p "$BACKUP_DIR/desktop"
cp -r ~/Desktop "$BACKUP_DIR/desktop/" 2>/dev/null
cp -r ~/.local/share/applications "$BACKUP_DIR/desktop/" 2>/dev/null

# ============================================================================
# 4. CUSTOM SCRIPTS
# ============================================================================
echo "🔧 Backing up custom scripts..."

mkdir -p "$BACKUP_DIR/custom-scripts"
cp -r ~/scripts "$BACKUP_DIR/custom-scripts/" 2>/dev/null
find ~ -maxdepth 2 -name "*.sh" -type f -exec cp {} "$BACKUP_DIR/custom-scripts/" \; 2>/dev/null

# ============================================================================
# 5. EMULATOR CONFIGURATIONS
# ============================================================================
echo "🎮 Backing up emulator configurations..."

mkdir -p "$BACKUP_DIR/emulator-configs"
cp ~/.mame/mame.ini "$BACKUP_DIR/emulator-configs/" 2>/dev/null
cp -r ~/.config/mame "$BACKUP_DIR/emulator-configs/" 2>/dev/null

# ============================================================================
# 6. NETWORK CONFIGURATION
# ============================================================================
echo "🌐 Backing up network configuration..."

mkdir -p "$BACKUP_DIR/network"
cp /etc/fstab "$BACKUP_DIR/network/" 2>/dev/null
cp -r ~/.config/samba "$BACKUP_DIR/network/" 2>/dev/null

# ============================================================================
# 7. SYSTEM CONFIGURATION
# ============================================================================
echo "⚙️ Backing up system configuration..."

mkdir -p "$BACKUP_DIR/system"
cp -r ~/.config/systemsettingsrc "$BACKUP_DIR/system/" 2>/dev/null
cp -r ~/.config/kcm* "$BACKUP_DIR/system/" 2>/dev/null

# ============================================================================
# 8. SECURITY AND KEYS
# ============================================================================
echo "🔐 Backing up security and keys..."

mkdir -p "$BACKUP_DIR/security"
cp -r ~/.ssh "$BACKUP_DIR/security/" 2>/dev/null
cp -r ~/.local/share/kwallet "$BACKUP_DIR/security/" 2>/dev/null
cp -r ~/.gnupg "$BACKUP_DIR/security/" 2>/dev/null

# ============================================================================
# 9. USER DATA
# ============================================================================
echo "📁 Backing up user data..."

mkdir -p "$BACKUP_DIR/user-data"
cp -r /run/media/duck/extra/User/Downloads/ProjectsMain "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Documents "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Pictures "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Music "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Videos "$BACKUP_DIR/user-data/" 2>/dev/null

# ============================================================================
# 10. STEAM DATA (OPTIONAL - LARGE)
# ============================================================================
echo "🎮 Checking Steam data (optional backup)..."
if [ -d ~/.local/share/Steam ]; then
    STEAM_SIZE=$(du -sh ~/.local/share/Steam | cut -f1)
    echo "Steam data size: $STEAM_SIZE"
    echo "💡 To backup Steam (large): cp -r ~/.local/share/Steam ~/.steam $BACKUP_DIR/steam/"
    echo "   Or skip and re-download games later"
fi

# ============================================================================
# 11. CREATE BACKUP SUMMARY
# ============================================================================
echo "📋 Creating backup summary..."

cat > "$BACKUP_DIR/backup-summary.md" << EOF
# CachyOS Pre-Reinstall Backup Summary

**Backup Date**: $(date)
**Backup Location**: $BACKUP_DIR

## What Was Backed Up:

### 🎨 KDE/Plasma Configuration
- All KDE configuration files
- Plasma desktop settings
- Window manager settings
- Theme and appearance settings

### 📱 Application Configurations
- FileZilla (network connections, sites)
- NordVPN settings
- Brave browser settings
- VS Code settings and extensions
- Windsurf configuration

### 🖥️ Desktop and Launchers
- All desktop icons and shortcuts
- Custom application launchers
- Panel configuration

### 🔧 Custom Scripts
- All shell scripts
- Emulator launch scripts
- Custom utility scripts

### 🎮 Emulator Configurations
- MAME configuration
- Emulator settings and ROM paths

### 🌐 Network Configuration
- fstab entries (network mounts)
- Samba configuration
- Network credentials

### ⚙️ System Configuration
- System settings
- KDE control module configurations

### 🔐 Security and Keys
- SSH keys
- KDE Wallet data
- GPG keys

### 📁 User Data
- ProjectsMain directory
- Documents, Pictures, Music, Videos

## Post-Reinstall Restoration Steps:

1. **Install CachyOS** with KDE Plasma
2. **Run post-install script** to recreate base setup
3. **Restore configurations** from this backup
4. **Test applications** and network connections
5. **Restore Steam games** (if backed up)

## Manual Backup Items to Consider:

- Large game files (if you want to avoid re-downloading)
- Any additional data in /run/media/duck/extra/User/
- Browser extensions and bookmarks
- Application-specific data in other locations

## Size Information:
$(du -sh "$BACKUP_DIR" | cut -f1) total backup size

---

**Restore Command**: \`cp -r $BACKUP_DIR/* ~/\`
**Note**: Run post-install script first, then restore configs
EOF

# ============================================================================
# 12. FINALIZE BACKUP
# ============================================================================
echo ""
echo "✅ Backup completed successfully!"
echo ""
echo "📁 Backup location: $BACKUP_DIR"
echo "📊 Total size: $(du -sh "$BACKUP_DIR" | cut -f1)"
echo ""
echo "📋 Backup summary created: $BACKUP_DIR/backup-summary.md"
echo ""
echo "🔄 After reinstall:"
echo "   1. Install CachyOS KDE"
echo "   2. Run: ./cachyos-comprehensive-post-install.sh"
echo "   3. Restore: cp -r $BACKUP_DIR/* ~/"
echo "   4. Reboot and test"
echo ""
echo "🎉 Pre-reinstall backup finished!"
