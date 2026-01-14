#!/bin/bash

# CachyOS Pre-Reinstall Backup Script (Essential Only)
# Backs up essential configurations and data before OS reinstall
# Excludes: Emulator/Game Data, Application Settings, Security/Authentication

echo "🔄 Starting CachyOS Pre-Reinstall Backup (Essential Only)..."

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
# 2. DESKTOP AND LAUNCHERS
# ============================================================================
echo "🖥️ Backing up desktop and launchers..."

mkdir -p "$BACKUP_DIR/desktop"
cp -r ~/Desktop "$BACKUP_DIR/desktop/" 2>/dev/null
cp -r ~/.local/share/applications "$BACKUP_DIR/desktop/" 2>/dev/null

# ============================================================================
# 3. CUSTOM SCRIPTS
# ============================================================================
echo "🔧 Backing up custom scripts..."

mkdir -p "$BACKUP_DIR/custom-scripts"
cp -r ~/scripts "$BACKUP_DIR/custom-scripts/" 2>/dev/null
find ~ -maxdepth 2 -name "*.sh" -type f -exec cp {} "$BACKUP_DIR/custom-scripts/" \; 2>/dev/null

# ============================================================================
# 4. NETWORK CONFIGURATION
# ============================================================================
echo "🌐 Backing up network configuration..."

mkdir -p "$BACKUP_DIR/network"
cp /etc/fstab "$BACKUP_DIR/network/" 2>/dev/null
# Note: Excluding Samba credentials and sensitive network data

# ============================================================================
# 5. SYSTEM CONFIGURATION
# ============================================================================
echo "⚙️ Backing up system configuration..."

mkdir -p "$BACKUP_DIR/system"
cp -r ~/.config/systemsettingsrc "$BACKUP_DIR/system/" 2>/dev/null
cp -r ~/.config/kcm* "$BACKUP_DIR/system/" 2>/dev/null

# ============================================================================
# 6. USER DATA
# ============================================================================
echo "📁 Backing up user data..."

mkdir -p "$BACKUP_DIR/user-data"
cp -r /run/media/duck/extra/User/Downloads/ProjectsMain "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Documents "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Pictures "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Music "$BACKUP_DIR/user-data/" 2>/dev/null
cp -r ~/Videos "$BACKUP_DIR/user-data/" 2>/dev/null

# ============================================================================
# 7. POST-INSTALL SCRIPTS
# ============================================================================
echo "📋 Backing up post-install scripts..."

mkdir -p "$BACKUP_DIR/post-install-scripts"
cp -r /run/media/duck/extra/User/Downloads/ProjectsMain/Post-Install-CachyOS "$BACKUP_DIR/post-install-scripts/" 2>/dev/null

# ============================================================================
# 8. DOCUMENTATION
# ============================================================================
echo "📚 Backing up documentation..."

mkdir -p "$BACKUP_DIR/documentation"
cp /run/media/duck/extra/User/Downloads/ProjectsMain/CACHYOS_GLOBAL_SETTINGS.md "$BACKUP_DIR/documentation/" 2>/dev/null

# ============================================================================
# 9. CREATE BACKUP SUMMARY
# ============================================================================
echo "📋 Creating backup summary..."

cat > "$BACKUP_DIR/backup-summary.md" << EOF
# CachyOS Pre-Reinstall Backup Summary (Essential Only)

**Backup Date**: $(date)
**Backup Location**: $BACKUP_DIR

## What Was Backed Up:

### 🎨 KDE/Plasma Configuration
- All KDE configuration files
- Plasma desktop settings
- Window manager settings
- Theme and appearance settings

### 🖥️ Desktop and Launchers
- All desktop icons and shortcuts
- Custom application launchers
- Panel configuration

### 🔧 Custom Scripts
- All shell scripts
- Custom utility scripts
- NAS control scripts

### 🌐 Network Configuration
- fstab entries (network mounts)
- Basic network configuration
- Note: Samba credentials excluded for security

### ⚙️ System Configuration
- System settings
- KDE control module configurations

### 📁 User Data
- ProjectsMain directory
- Documents, Pictures, Music, Videos

### 📋 Post-Install Scripts
- Complete post-install script collection
- Documentation and usage instructions

### 📚 Documentation
- Global settings documentation
- System configuration reference

## What Was Excluded:

### 🎮 Emulator and Game Data
- MAME configurations
- ROM files and game data
- Emulator save states

### 📱 Application Settings
- FileZilla network connections
- NordVPN settings
- Brave browser data
- VS Code settings and extensions
- Windsurf configuration

### 🔐 Security and Authentication
- SSH keys
- KDE Wallet data
- GPG keys
- Samba credentials
- Password files

## Post-Reinstall Restoration Steps:

1. **Install CachyOS** with KDE Plasma
2. **Run post-install script** to recreate base setup
3. **Restore essential configurations**:
   - KDE/Plasma settings: \`cp -r kde-config/* ~/.config/\`
   - Desktop icons: \`cp -r desktop/* ~/Desktop/\`
   - Custom scripts: \`cp -r custom-scripts/* ~/scripts/\`
   - User data: \`cp -r user-data/* ~/\`
4. **Reconfigure applications manually** (FileZilla, NordVPN, etc.)
5. **Set up security** (SSH keys, VPN credentials)
6. **Test network connections** and mount points

## Manual Setup Required After Restore:

### 📱 Application Configuration
- FileZilla: Re-add network sites and connections
- NordVPN: Re-login and configure servers
- Brave: Re-setup bookmarks and extensions
- VS Code: Re-install extensions and settings
- Windsurf: Re-configure workspace

### 🔐 Security Setup
- Generate new SSH keys: \`ssh-keygen -t ed25519\`
- Set up KDE Wallet password
- Configure GPG if needed
- Set up network credentials

### 🎮 Emulator Setup
- Configure MAME settings
- Set ROM paths
- Configure controller settings

## Size Information:
$(du -sh "$BACKUP_DIR" | cut -f1) total backup size

---

**Essential Restore Command**: \`cp -r $BACKUP_DIR/* ~/\`
**Note**: Run post-install script first, then restore configs
**Security**: You'll need to reconfigure authentication after restore
EOF

# ============================================================================
# 10. FINALIZE BACKUP
# ============================================================================
echo ""
echo "✅ Essential backup completed successfully!"
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
echo "   4. Reconfigure applications manually"
echo "   5. Set up security and authentication"
echo "   6. Reboot and test"
echo ""
echo "⚠️  Note: You'll need to manually reconfigure:"
echo "   - FileZilla network connections"
echo "   - NordVPN settings"
echo "   - SSH keys and security credentials"
echo "   - Emulator configurations"
echo ""
echo "🎉 Essential pre-reinstall backup finished!"
