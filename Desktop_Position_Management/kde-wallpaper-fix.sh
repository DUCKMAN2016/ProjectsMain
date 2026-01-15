#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# KDE Plasma Wallpaper Script
# Uses KDE's built-in wallpaper setting methods

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🖼️  KDE Wallpaper Script Restoration${NC}"
echo "================================="
echo ""

echo -e "${BLUE}🔧 Setting wallpapers using KDE methods...${NC}"

# Method 1: Try qdbus6 for Monitor 1
echo -e "${YELLOW}Setting Monitor 1 wallpaper (It-Pc.png)...${NC}"
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (i=0;i<allDesktops.length;i++) {
    d = allDesktops[i];
    if (d.screen === 0) {
        d.wallpaperPlugin = 'org.kde.image';
        d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        d.writeConfig('Image', 'file:///home/duck/Pictures/It-Pc.png');
    }
}
" 2>/dev/null

# Method 2: Try qdbus6 for Monitor 2
echo -e "${YELLOW}Setting Monitor 2 wallpaper (Me-n-MrsFrankenstein.jpg)...${NC}"
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (i=0;i<allDesktops.length;i++) {
    d = allDesktops[i];
    if (d.screen === 1) {
        d.wallpaperPlugin = 'org.kde.image';
        d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        d.writeConfig('Image', 'file:///home/duck/Pictures/Me-n-MrsFrankenstein.jpg');
    }
}
" 2>/dev/null

# Method 2: Try kwriteconfig5 for direct config editing
echo -e "${YELLOW}Setting Monitor 2 wallpaper...${NC}"
kwriteconfig6 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletrc" --group "Containments][2][Wallpaper][org.kde.image][General" --key "Image" --type "string" "/home/duck/Pictures/Me-n-MrsFrankenstein.jpg"

# Method 3: Try kwriteconfig5 for Monitor 1
echo -e "${YELLOW}Ensuring Monitor 1 wallpaper is set...${NC}"
kwriteconfig6 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" --group "Containments][1][Wallpaper][org.kde.image][General" --key "Image" --type "string" "/home/duck/Pictures/It-Pc.png"

echo -e "${GREEN}✅ Wallpaper commands executed${NC}"
echo ""
echo -e "${BLUE}📋 Attempted to set:${NC}"
echo "   • Monitor 1: /home/duck/Pictures/It-Pc.png"
echo "   • Monitor 2: /home/duck/Pictures/Me-n-MrsFrankenstein.jpg"
echo ""
echo -e "${YELLOW}⚠️  If wallpapers don't appear, try:${NC}"
echo "   1. Right-click desktop → Configure Desktop → Wallpaper"
echo "   2. Or restart plasma: ./restart-plasma.sh"
echo ""
echo -e "${GREEN}🎯 Alternative method completed!${NC}"
