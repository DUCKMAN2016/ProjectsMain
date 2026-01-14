#!/bin/bash

# CachyOS System Configuration Discovery Script
# Captures all current configurations for comprehensive post-install script creation

echo "🔍 Starting CachyOS System Configuration Discovery..."

# Create output directory
DISCOVERY_DIR="$HOME/cachyos-discovery-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DISCOVERY_DIR"
echo "📁 Discovery directory: $DISCOVERY_DIR"

# 1. Network Configuration Discovery
echo "🌐 Discovering Network Configuration..."

# NAS and network mounts
echo "=== FSTAB Configuration ===" > "$DISCOVERY_DIR/fstab-config.txt"
cat /etc/fstab >> "$DISCOVERY_DIR/fstab-config.txt"

# Network shares and connections
echo "=== Network Configuration ===" > "$DISCOVERY_DIR/network-config.txt"
echo "SMB/CIFS connections:" >> "$DISCOVERY_DIR/network-config.txt"
grep -r "192.168" /home/duck/.config/ 2>/dev/null | head -20 >> "$DISCOVERY_DIR/network-config.txt"

# Hosts file
echo -e "\n=== /etc/hosts ===" >> "$DISCOVERY_DIR/network-config.txt"
cat /etc/hosts >> "$DISCOVERY_DIR/network-config.txt"

# 2. Desktop Icons Discovery
echo "🖥️ Discovering Desktop Icons..."
echo "=== Desktop Icons ===" > "$DISCOVERY_DIR/desktop-icons.txt"
ls -la /home/duck/Desktop/ >> "$DISCOVERY_DIR/desktop-icons.txt"

# Extract .desktop file details
echo -e "\n=== Desktop Launcher Details ===" >> "$DISCOVERY_DIR/desktop-icons.txt"
find /home/duck/Desktop -name "*.desktop" -exec echo "File: {}" \; -exec grep -E "^Name=|^Exec=|^Icon=" {} \; >> "$DISCOVERY_DIR/desktop-icons.txt"

# 3. Taskbar/Panel Configuration Discovery
echo "📋 Discovering Taskbar/Panel Configuration..."
echo "=== Panel Configuration ===" > "$DISCOVERY_DIR/panel-config.txt"

# Extract panel applets and launchers
grep -A 10 -B 5 "launchers=" /home/duck/.config/plasma-org.kde.plasma.desktop-appletsrc >> "$DISCOVERY_DIR/panel-config.txt"

# Extract panel widgets
echo -e "\n=== Panel Widgets ===" >> "$DISCOVERY_DIR/panel-config.txt"
grep -E "plugin=org\.kde\.plasma\." /home/duck/.config/plasma-org.kde.plasma.desktop-appletsrc >> "$DISCOVERY_DIR/panel-config.txt"

# 4. Application Menu and Favorites Discovery
echo "📱 Discovering Application Menu and Favorites..."
echo "=== Application Favorites ===" > "$DISCOVERY_DIR/favorites-config.txt"

# Kickoff launcher favorites
grep -A 5 -B 5 "favoritesPortedToKAstats" /home/duck/.config/plasma-org.kde.plasma.desktop-appletsrc >> "$DISCOVERY_DIR/favorites-config.txt"

# System favorites
echo -e "\n=== System Favorites ===" >> "$DISCOVERY_DIR/favorites-config.txt"
grep "systemFavorites=" /home/duck/.config/plasma-org.kde.plasma.desktop-appletsrc >> "$DISCOVERY_DIR/favorites-config.txt"

# 5. Installed Applications Discovery
echo "📦 Discovering Installed Applications..."

# System applications
echo "=== System Applications (.desktop files) ===" > "$DISCOVERY_DIR/installed-apps.txt"
find /usr/share/applications -name "*.desktop" | head -50 >> "$DISCOVERY_DIR/installed-apps.txt"

# User applications
echo -e "\n=== User Applications (.desktop files) ===" >> "$DISCOVERY_DIR/installed-apps.txt"
find /home/duck/.local/share/applications -name "*.desktop" 2>/dev/null >> "$DISCOVERY_DIR/installed-apps.txt"

# Extract app names and commands
echo -e "\n=== Application Details ===" >> "$DISCOVERY_DIR/installed-apps.txt"
for app in $(find /usr/share/applications /home/duck/.local/share/applications -name "*.desktop" 2>/dev/null | head -20); do
    echo "File: $app" >> "$DISCOVERY_DIR/installed-apps.txt"
    grep -E "^Name=|^Exec=|^Categories=" "$app" 2>/dev/null | head -3 >> "$DISCOVERY_DIR/installed-apps.txt"
    echo "" >> "$DISCOVERY_DIR/installed-apps.txt"
done

# 6. KDE Configuration Files Discovery
echo "⚙️ Discovering KDE Configuration..."
echo "=== KDE Config Files ===" > "$DISCOVERY_DIR/kde-configs.txt"

# Main KDE config files
for config in kdeglobals kwinrc plasmarc systemsettingsrc; do
    if [ -f "/home/duck/.config/$config" ]; then
        echo -e "\n=== $config ===" >> "$DISCOVERY_DIR/kde-configs.txt"
        cat "/home/duck/.config/$config" >> "$DISCOVERY_DIR/kde-configs.txt"
    fi
done

# 7. Wallpaper and Theme Discovery
echo "🎨 Discovering Wallpaper and Theme Configuration..."
echo "=== Wallpaper Configuration ===" > "$DISCOVERY_DIR/theme-config.txt"

# Extract wallpaper settings
grep -A 5 -B 5 "Image=" /home/duck/.config/plasma-org.kde.plasma.desktop-appletsrc >> "$DISCOVERY_DIR/theme-config.txt"

# Theme information
echo -e "\n=== Theme Information ===" >> "$DISCOVERY_DIR/theme-config.txt"
grep "LookAndFeelPackage" /home/duck/.config/kdeglobals >> "$DISCOVERY_DIR/theme-config.txt"

# 8. User Scripts and Custom Launchers Discovery
echo "🔧 Discovering User Scripts and Custom Launchers..."
echo "=== User Scripts ===" > "$DISCOVERY_DIR/user-scripts.txt"

# Find user scripts
find /home/duck -name "*.sh" -type f | grep -v ".cache" | head -20 >> "$DISCOVERY_DIR/user-scripts.txt"

# Custom desktop launchers
echo -e "\n=== Custom Desktop Launchers ===" >> "$DISCOVERY_DIR/user-scripts.txt"
find /home/duck/Desktop -name "*.desktop" -type f -exec echo "--- {} ---" \; -exec cat {} \; >> "$DISCOVERY_DIR/user-scripts.txt"

# 9. Services and Autostart Discovery
echo "🚀 Discovering Services and Autostart..."
echo "=== User Services ===" > "$DISCOVERY_DIR/services-config.txt"

# User services
systemctl --user list-unit-files --state=enabled >> "$DISCOVERY_DIR/services-config.txt"

# Autostart applications
echo -e "\n=== Autostart Applications ===" >> "$DISCOVERY_DIR/services-config.txt"
ls -la /home/duck/.config/autostart/ 2>/dev/null >> "$DISCOVERY_DIR/services-config.txt"

# 10. Create Summary Report
echo "📋 Creating Summary Report..."
cat > "$DISCOVERY_DIR/discovery-summary.md" << EOF
# CachyOS System Configuration Discovery Summary

## Discovery Date: $(date)

## Files Generated:
- \`fstab-config.txt\` - File system mounts and network storage
- \`network-config.txt\` - Network configuration and SMB connections
- \`desktop-icons.txt\` - Desktop icons and custom launchers
- \`panel-config.txt\` - Taskbar/panel configuration and widgets
- \`favorites-config.txt\` - Application menu favorites and system favorites
- \`installed-apps.txt\` - All installed applications with details
- \`kde-configs.txt\` - KDE configuration files (kdeglobals, kwinrc, etc.)
- \`theme-config.txt\` - Wallpaper and theme configuration
- \`user-scripts.txt\` - Custom scripts and launchers
- \`services-config.txt\` - System services and autostart applications

## Key Findings:

### Desktop Icons:
$(ls /home/duck/Desktop/ | wc -l) items found on desktop

### Panel Launchers:
$(grep -o "applications:[^,]*" /home/duck/.config/plasma-org.kde.plasma.desktop-appletsrc | wc -l) launchers configured

### Network Storage:
$(grep -c "192.168" /home/duck/.config/filezilla/*.xml 2>/dev/null || echo "0") network connections found

### Custom Scripts:
$(find /home/duck -name "*.sh" -type f | grep -v ".cache" | wc -l) user scripts found

## Next Steps:
1. Review each configuration file
2. Identify settings to preserve in post-install script
3. Create automated configuration commands
4. Test post-install script on fresh system

EOF

echo ""
echo "✅ System Configuration Discovery Complete!"
echo "📁 All findings saved to: $DISCOVERY_DIR"
echo "📋 Summary report: $DISCOVERY_DIR/discovery-summary.md"
echo ""
echo "🔍 Key files to review:"
echo "   - desktop-icons.txt (Desktop shortcuts)"
echo "   - panel-config.txt (Taskbar setup)"
echo "   - installed-apps.txt (Applications to install)"
echo "   - fstab-config.txt (Network mounts)"
echo "   - kde-configs.txt (KDE settings)"
echo ""
echo "📊 Discovery completed at $(date)"
