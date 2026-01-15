#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Direct Wallpaper Restoration Script
# Sets wallpapers to correct paths directly

PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🖼️  Direct Wallpaper Restoration${NC}"
echo "=============================="
echo ""

# Check if wallpaper files exist
if [ ! -f "/home/duck/Pictures/It-Pc.png" ]; then
    echo -e "${RED}❌ Wallpaper not found: /home/duck/Pictures/It-Pc.png${NC}"
    exit 1
fi

if [ ! -f "/home/duck/Pictures/Me-n-MrsFrankenstein.jpg" ]; then
    echo -e "${RED}❌ Wallpaper not found: /home/duck/Pictures/Me-n-MrsFrankenstein.jpg${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found wallpapers: It-Pc.png & Me-n-MrsFrankenstein.jpg${NC}"

# Backup current config first
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
cp "$PLASMA_CONFIG" "$PLASMA_CONFIG.backup-before-wallpaper-fix-$TIMESTAMP"
echo -e "${GREEN}✓ Current config backed up${NC}"

echo -e "${BLUE}🔧 Setting correct wallpaper paths...${NC}"

# Create a temporary file with correct wallpaper settings
temp_file=$(mktemp)

# Process the config file and replace wallpaper paths
awk '
BEGIN { in_wallpaper_section = 0; changed = 0 }
/\[Containments\]/ { 
    if ($0 ~ /\[1\]/ || $0 ~ /\[2\]/) {
        in_desktop = 1
        print $0
        next
    }
}
in_desktop && /\[Wallpaper\]\[org\.kde\.image\]\[General\]/ {
    in_wallpaper_section = 1
    print $0
    next
}
in_wallpaper_section && /Image=/ {
    if (in_desktop && desktop_id == 1) {
        print "Image=/home/duck/Pictures/It-Pc.png"
        changed++
    } else if (in_desktop && desktop_id == 2) {
        print "Image=/home/duck/Pictures/Me-n-MrsFrankenstein.jpg"
        changed++
    } else {
        print $0
    }
    next
}
in_wallpaper_section && /\[.*\]/ && !/\[Wallpaper\]/ {
    in_wallpaper_section = 0
    print $0
    next
}
/\[Containments\]/ {
    if ($0 ~ /\[1\]/) desktop_id = 1
    else if ($0 ~ /\[2\]/) desktop_id = 2
    else desktop_id = 0
    in_desktop = 1
}
{ print }
END {
    print "# Wallpaper changes made: " changed
}
' "$PLASMA_CONFIG" > "$temp_file"

# Replace the config file
mv "$temp_file" "$PLASMA_CONFIG"

echo -e "${GREEN}✅ Wallpaper paths updated${NC}"
echo ""
echo -e "${BLUE}📋 Set wallpapers to:${NC}"
echo "   • Monitor 1: /home/duck/Pictures/It-Pc.png"
echo "   • Monitor 2: /home/duck/Pictures/Me-n-MrsFrankenstein.jpg"
echo ""
echo -e "${YELLOW}⚠️  Restart plasmashell to apply changes:${NC}"
echo "   ./restart-plasma.sh"
echo ""
echo -e "${GREEN}🎯 Your wallpapers should be restored correctly!${NC}"
