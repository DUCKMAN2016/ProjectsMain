#!/bin/bash

# CachyOS KDE Plasma Post-Install Configuration Script
# Automatically applies all documented global settings and theme configurations

echo "🚀 Starting CachyOS KDE Plasma Configuration..."

# Check if running as user (not root)
if [ "$EUID" -eq 0 ]; then
    echo "❌ Please run this script as your regular user, not as root"
    exit 1
fi

# Create backup directory
BACKUP_DIR="$HOME/.config/kde-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "📁 Created backup directory: $BACKUP_DIR"

# Backup existing configs
echo "💾 Backing up existing configurations..."
[ -f "$HOME/.config/kdeglobals" ] && cp "$HOME/.config/kdeglobals" "$BACKUP_DIR/"
[ -f "$HOME/.config/kwinrc" ] && cp "$HOME/.config/kwinrc" "$BACKUP_DIR/"
[ -f "$HOME/.config/plasmarc" ] && cp "$HOME/.config/plasmarc" "$BACKUP_DIR/"

# Apply KDE Global Theme Settings
echo "🎨 Applying KDE Global Theme Settings..."

# Set global theme to KDE-Story-Dark-Global-6
kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.kde-story-dark-global-6.desktop"

# Apply window decoration settings
echo "🪟 Applying Window Decoration Settings..."
kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key ButtonsOnLeft "SFB"  # Close, Keep Below, Keep Above
kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key ButtonsOnRight "I"     # Pin to All Desktops

# Apply desktop effects
echo "✨ Applying Desktop Effects..."
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key fallapartEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key hidecursorEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key kwin4_effect_geometry_changeEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key magiclampEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key translucencyEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key wobblywindowsEnabled "true"

# Configure blur effect strength
kwriteconfig6 --file kwinrc --group "Effect-blur" --key BlurStrength "9"
kwriteconfig6 --file kwinrc --group "Effect-blur" --key NoiseStrength "0"

# Apply panel configuration
echo "📋 Applying Panel Configuration..."
# Note: Panel configuration often requires plasma-shell restart
# This sets up the basic structure, but fine-tuning may need manual adjustment

# Set default browser
echo "🌐 Setting Default Browser..."
kwriteconfig6 --file kdeglobals --group General --key BrowserApplication "brave-browser.desktop"

# Apply Dolphin settings
echo "📁 Applying Dolphin File Manager Settings..."
kwriteconfig6 --file kdeglobals --group "KFileDialog Settings" --key View_Style "DetailTree"
kwriteconfig6 --file kdeglobals --group "KFileDialog Settings" --key SortDirectoriesFirst "true"
kwriteconfig6 --file kdeglobals --group "KFileDialog Settings" --key ShowHiddenFiles "false"

# Enable/disable system services
echo "⚙️ Configuring System Services..."
# Note: Some services require sudo, others are user-specific
systemctl --user enable --now plasma-plasmashell.service 2>/dev/null || true

# Restart KDE components to apply changes
echo "🔄 Restarting KDE components to apply changes..."

# Kill and restart kwin for effects to take effect
kwin_x11 --replace &
sleep 2

# Restart plasma shell
kquitapp6 plasmashell 2>/dev/null || kquitapp5 plasmashell 2>/dev/null || true
sleep 3
plasmashell &

# Apply transparency settings (requires manual step)
echo "🔍 Transparency Configuration:"
echo "   Manual step required: Go to System Settings → Global Themes → Application Style → Transparency tab"
echo "   Click edit icon (pencil) and configure transparency settings"

# Apply Magic Lamp effect (requires manual step)
echo "🪄 Magic Lamp Effect Configuration:"
echo "   Manual step required: Go to System Settings → Workspace → Desktop Effects → Animations"
echo "   Change 'Window Minimize' effect to 'Magic Lamp'"

# Panel configuration (requires manual step)
echo "📋 Panel Configuration:"
echo "   Manual step required: Right-click panel → Configure Panel"
echo "   Set Position: Top, Width: Custom, Opacity: Translucent"

echo ""
echo "✅ Automatic configuration completed!"
echo ""
echo "📝 Manual steps required:"
echo "   1. Configure transparency settings in Application Style"
echo "   2. Set Magic Lamp effect in Desktop Effects → Animations"
echo "   3. Configure panel position and opacity"
echo ""
echo "🔄 Reboot or log out/in to ensure all changes take effect"
echo "💾 Backups stored in: $BACKUP_DIR"
echo ""
echo "🎉 CachyOS KDE Plasma configuration script finished!"
