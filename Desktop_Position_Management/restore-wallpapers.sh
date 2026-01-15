#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Wallpaper Restoration Script
# Restores wallpaper settings from backup configuration

PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
BACKUP_CONFIG="/run/media/duck/extra/User/Downloads/ProjectsMain/Post-Install-CachyOS/wallpaper-config/plasma-org.kde.plasma.desktop-appletsrc"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🖼️  Wallpaper Restoration${NC}"
echo "=========================="
echo ""

if [ ! -f "$BACKUP_CONFIG" ]; then
    echo -e "${RED}❌ Backup wallpaper config not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found wallpaper backup configuration${NC}"
echo -e "${BLUE}📁 Restoring wallpaper settings...${NC}"

# Backup current config first
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
cp "$PLASMA_CONFIG" "$PLASMA_CONFIG.backup-before-wallpaper-restore-$TIMESTAMP"
echo -e "${GREEN}✓ Current config backed up${NC}"

# Extract wallpaper sections from backup and apply to current config
awk '
BEGIN { in_wallpaper_section = 0; wallpaper_found = 0 }
/\[Containments\].*\[Wallpaper\]/ { in_wallpaper_section = 1; wallpaper_found = 1; print; next }
in_wallpaper_section && /\[.*\]/ && !/\[Containments\]/ && !/\[Wallpaper\]/ { in_wallpaper_section = 0; print; next }
in_wallpaper_section { print }
!in_wallpaper_section && !/\[Containments\].*\[Wallpaper\]/ { print }
END {
    if (!wallpaper_found) {
        print "# No wallpaper sections found in backup"
    }
}
' "$BACKUP_CONFIG" > "$PLASMA_CONFIG.tmp" && mv "$PLASMA_CONFIG.tmp" "$PLASMA_CONFIG"

echo -e "${GREEN}✅ Wallpaper configuration restored${NC}"
echo ""
echo -e "${BLUE}📋 Restoring wallpapers:${NC}"
echo "   • Monitor 1: It-Pc.png"
echo "   • Monitor 2: Fuji-Dark.png"
echo ""
echo -e "${YELLOW}⚠️  Restart plasmashell to apply changes:${NC}"
echo "   cd /run/media/duck/extra/User/Downloads/ProjectsMain/Desktop_Position_Management && ./restart-plasma.sh"
echo ""
echo -e "${GREEN}🎯 Your wallpapers should be restored after plasma restart!${NC}"
