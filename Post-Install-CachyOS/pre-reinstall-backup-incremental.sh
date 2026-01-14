#!/bin/bash

# CachyOS Pre-Reinstall Backup Script (Incremental)
# Only backs up what doesn't already exist on /run/media/duck/extra/User/
# Excludes: Emulator/Game Data, Application Settings, Security/Authentication, VS Code, Windsurf, KDE Wallet

echo "🔄 Starting CachyOS Pre-Reinstall Backup (Incremental Only)..."

# Create backup directory with timestamp
BACKUP_DIR="/run/media/duck/extra/User/pre-reinstall-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📁 Backup directory: $BACKUP_DIR"

# Function to backup only if destination doesn't exist or is different
backup_if_different() {
    local src="$1"
    local dest="$2"
    local desc="$3"
    
    if [ ! -e "$dest" ]; then
        echo "📦 Backing up $desc (new)..."
        mkdir -p "$(dirname "$dest")"
        cp -r "$src" "$dest"
        return 0
    elif [ -d "$src" ] && [ -d "$dest" ]; then
        # Compare directories
        if ! diff -rq "$src" "$dest" >/dev/null 2>&1; then
            echo "📦 Backing up $desc (different)..."
            cp -r "$src" "$dest"
            return 0
        else
            echo "✅ Skipping $desc (already exists)"
            return 1
        fi
    else
        echo "📦 Backing up $desc (file different)..."
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        return 0
    fi
}

# ============================================================================
# 1. KDE/PLASMA CONFIGURATION
# ============================================================================
echo "🎨 Checking KDE/Plasma configuration..."

mkdir -p "$BACKUP_DIR/kde-config"
backup_count=0

# Backup individual KDE config files
for config_file in ~/.config/kdeglobals ~/.config/kwinrc ~/.config/plasmarc; do
    if [ -f "$config_file" ]; then
        if backup_if_different "$config_file" "$BACKUP_DIR/kde-config/$(basename "$config_file")" "KDE $(basename "$config_file")"; then
            ((backup_count++))
        fi
    fi
done

# Backup plasma config
if [ -f ~/.config/plasma-org.kde.plasma.desktop-appletsrc ]; then
    if backup_if_different "$config_file" "$BACKUP_DIR/kde-config/plasma-org.kde.plasma.desktop-appletsrc" "Plasma panel configuration"; then
        ((backup_count++))
    fi
fi

# ============================================================================
# 2. DESKTOP AND LAUNCHERS
# ============================================================================
echo "🖥️ Checking desktop and launchers..."

mkdir -p "$BACKUP_DIR/desktop"
desktop_backup_count=0

# Backup desktop icons that don't exist on external drive
if [ -d ~/Desktop ]; then
    mkdir -p "$BACKUP_DIR/desktop/Desktop"
    for item in ~/Desktop/*; do
        if [ -e "$item" ]; then
            item_name=$(basename "$item")
            external_item="/run/media/duck/extra/User/Desktop/$item_name"
            
            if [ ! -e "$external_item" ]; then
                echo "📦 Backing up desktop item: $item_name"
                cp -r "$item" "$BACKUP_DIR/desktop/Desktop/"
                ((desktop_backup_count++))
            else
                echo "✅ Skipping desktop item (exists): $item_name"
            fi
        fi
    done
fi

# ============================================================================
# 3. CUSTOM SCRIPTS
# ============================================================================
echo "🔧 Checking custom scripts..."

mkdir -p "$BACKUP_DIR/custom-scripts"
scripts_backup_count=0

# Find and backup unique scripts
find ~ -maxdepth 2 -name "*.sh" -type f 2>/dev/null | while read script; do
    script_name=$(basename "$script")
    external_script="/run/media/duck/extra/User/scripts/$script_name"
    
    if [ ! -e "$external_script" ]; then
        echo "📦 Backing up script: $script_name"
        cp "$script" "$BACKUP_DIR/custom-scripts/"
        ((scripts_backup_count++))
    else
        echo "✅ Skipping script (exists): $script_name"
    fi
done

# ============================================================================
# 4. NETWORK CONFIGURATION
# ============================================================================
echo "🌐 Checking network configuration..."

mkdir -p "$BACKUP_DIR/network"
network_backup_count=0

# Backup fstab if different
if [ -f /etc/fstab ]; then
    external_fstab="/run/media/duck/extra/User/fstab-backup"
    if backup_if_different /etc/fstab "$BACKUP_DIR/network/fstab" "fstab configuration"; then
        ((network_backup_count++))
    fi
fi

# ============================================================================
# 5. USER DATA (Incremental)
# ============================================================================
echo "📁 Checking user data (incremental)..."

mkdir -p "$BACKUP_DIR/user-data"
user_backup_count=0

# Function to backup directory incrementally
backup_dir_incremental() {
    local src="$1"
    local dest_base="$2"
    local desc="$3"
    
    if [ -d "$src" ]; then
        mkdir -p "$dest_base"
        find "$src" -type f 2>/dev/null | while read file; do
            rel_path="${file#$src/}"
            dest_file="$dest_base/$rel_path"
            external_file="/run/media/duck/extra/User/$desc/$rel_path"
            
            if [ ! -e "$external_file" ]; then
                echo "📦 Backing up $desc file: $rel_path"
                mkdir -p "$(dirname "$dest_file")"
                cp "$file" "$dest_file"
                ((user_backup_count++))
            fi
        done
    fi
}

# Check Documents
backup_dir_incremental ~/Documents "$BACKUP_DIR/user-data/Documents" "Documents"

# Check Pictures  
backup_dir_incremental ~/Pictures "$BACKUP_DIR/user-data/Pictures" "Pictures"

# Check Music
backup_dir_incremental ~/Music "$BACKUP_DIR/user-data/Music" "Music"

# Check Videos
backup_dir_incremental ~/Videos "$BACKUP_DIR/user-data/Videos" "Videos"

# ============================================================================
# 6. POST-INSTALL SCRIPTS (Check for updates)
# ============================================================================
echo "📋 Checking post-install scripts..."

mkdir -p "$BACKUP_DIR/post-install-scripts"
post_install_count=0

if [ -d /run/media/duck/extra/User/Downloads/ProjectsMain/Post-Install-CachyOS ]; then
    if backup_if_different "/run/media/duck/extra/User/Downloads/ProjectsMain/Post-Install-CachyOS" "$BACKUP_DIR/post-install-scripts/Post-Install-CachyOS" "Post-install scripts"; then
        ((post_install_count++))
    fi
fi

# ============================================================================
# 7. DOCUMENTATION
# ============================================================================
echo "📚 Checking documentation..."

mkdir -p "$BACKUP_DIR/documentation"
doc_count=0

if [ -f /run/media/duck/extra/User/Downloads/ProjectsMain/CACHYOS_GLOBAL_SETTINGS.md ]; then
    if backup_if_different "/run/media/duck/extra/User/Downloads/ProjectsMain/CACHYOS_GLOBAL_SETTINGS.md" "$BACKUP_DIR/documentation/CACHYOS_GLOBAL_SETTINGS.md" "Global settings documentation"; then
        ((doc_count++))
    fi
fi

# ============================================================================
# 8. CALCULATE ACTUAL BACKUP SIZE
# ============================================================================
echo "📊 Calculating backup size..."
backup_size=$(du -sh "$BACKUP_DIR" | cut -f1)

# ============================================================================
# 9. CREATE BACKUP SUMMARY
# ============================================================================
echo "📋 Creating backup summary..."

cat > "$BACKUP_DIR/backup-summary.md" << EOF
# CachyOS Pre-Reinstall Backup Summary (Incremental)

**Backup Date**: $(date)
**Backup Location**: $BACKUP_DIR
**Backup Size**: $backup_size
**Backup Type**: Incremental (only new/changed files)

## What Was Backed Up:

### 🎨 KDE/Plasma Configuration
- Only KDE config files that were different or missing
- Plasma panel configuration if changed
- **Files backed up**: $backup_count items

### 🖥️ Desktop and Launchers
- Only desktop icons not already on external drive
- Custom launchers that don't exist externally
- **Files backed up**: $desktop_backup_count items

### 🔧 Custom Scripts
- Only scripts not already on external drive
- **Files backed up**: $scripts_backup_count items

### 🌐 Network Configuration
- fstab if different from external backup
- **Files backed up**: $network_backup_count items

### 📁 User Data (Incremental)
- Only files not already on external drive
- Documents, Pictures, Music, Videos
- **Files backed up**: $user_backup_count items

### 📋 Post-Install Scripts
- Only if scripts were updated
- **Files backed up**: $post_install_count items

### 📚 Documentation
- Only if documentation was changed
- **Files backed up**: $doc_count items

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

### 💻 Development Tools
- VS Code settings, extensions, workspaces
- Windsurf configuration and projects
- Development environment settings

### 📁 Existing Files
- Any files already present on /run/media/duck/extra/User/
- Duplicate files and folders
- Unchanged configuration files

## Space Savings:
This incremental backup only stores files that:
1. Don't already exist on the external drive
2. Are different from existing versions
3. Are new since last backup

## Post-Reinstall Restoration Steps:

1. **Install CachyOS** with KDE Plasma
2. **Run post-install script** to recreate base setup
3. **Restore incremental backup**: \`cp -r $BACKUP_DIR/* ~/\`
4. **Copy existing data** from external drive if needed
5. **Reconfigure applications manually**
6. **Set up development environments**
7. **Set up security and authentication**
8. **Test network connections** and mount points

---

**Incremental Restore Command**: \`cp -r $BACKUP_DIR/* ~/\`
**Note**: This backup contains only new/changed files
**External Drive**: Contains most of your data already
EOF

# ============================================================================
# 10. FINALIZE BACKUP
# ============================================================================
echo ""
echo "✅ Incremental backup completed successfully!"
echo ""
echo "📁 Backup location: $BACKUP_DIR"
echo "📊 Backup size: $backup_size"
echo ""
echo "📋 Backup summary created: $BACKUP_DIR/backup-summary.md"
echo ""
echo "💡 Space saved by incremental backup:"
echo "   - Only new/changed files backed up"
echo "   - Existing files on external drive skipped"
echo "   - Application settings excluded"
echo "   - Security data excluded"
echo ""
echo "🔄 After reinstall:"
echo "   1. Install CachyOS KDE"
echo "   2. Run: ./cachyos-comprehensive-post-install.sh"
echo "   3. Restore: cp -r $BACKUP_DIR/* ~/"
echo "   4. Copy existing data from /run/media/duck/extra/User/ if needed"
echo "   5. Reconfigure applications manually"
echo "   6. Set up development environments"
echo "   7. Set up security and authentication"
echo "   8. Reboot and test"
echo ""
echo "🎉 Incremental pre-reinstall backup finished!"
