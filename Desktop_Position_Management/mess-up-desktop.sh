#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Desktop Icon Chaos Script
# Temporarily messes up desktop icons for testing restoration tools

DESKTOP_DIR="$HOME/Desktop"
PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
BACKUP_DIR="$HOME/.config/desktop-icon-backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌪️  Desktop Icon Chaos Test${NC}"
echo "=============================="
echo ""
echo -e "${YELLOW}⚠️  This will temporarily mess up your desktop icons!${NC}"
echo -e "${YELLOW}   Don't worry - we have backup tools to restore them${NC}"
echo ""

# Create backup before messing things up
if [ -f "$PLASMA_CONFIG" ]; then
    cp "$PLASMA_CONFIG" "$BACKUP_DIR/plasma-config-before-chaos-$TIMESTAMP.conf"
    echo -e "${GREEN}✓ Current config backed up${NC}"
fi

echo -e "${BLUE}🎲 Creating desktop chaos...${NC}"
echo ""

# Create a temporary file with scrambled positions
temp_file=$(mktemp)

# Generate scrambled positions (random but valid)
cat > "$temp_file" << 'EOF'
[Containments][43]
formfactor=0
immutability=1
lastScreen=0
location=0
plugin=org.kde.plasma.folder
wallpaperplugin=org.kde.image

[Containments][43][General]
positions={"1366x768":["2","5","desktop:/btop.desktop","0","3","desktop:/Cool_Retro_Term.desktop","1","9","desktop:/Defender.desktop","2","0","desktop:/DOS-Games-Launcher.desktop","0","7","desktop:/Full Shutdown.desktop","1","4","desktop:/Galaxy-Wars.desktop","2","2","desktop:/handbrake.desktop","0","1","desktop:/Kaypro.desktop","1","6","desktop:/Lock Screen.desktop","2","8","desktop:/Logout.desktop","0","11","desktop:/MAME-Settings.desktop","1","2","desktop:/Ms-Pac-Man.desktop","2","10","desktop:/myz80.desktop","0","4","desktop:/Newshosting.desktop","1","0","desktop:/Newshosting Downloads.desktop","2","6","desktop:/nordvpn-gui.desktop","0","8","desktop:/octopi.desktop","1","5","desktop:/Pac-Man.desktop","2","3","desktop:/Power Off.desktop","0","2","desktop:/qbittorrent.desktop","1","7","desktop:/Rainbow_MAME.desktop","2","9","desktop:/Reboot.desktop","0","10","desktop:/refresh-desktop.desktop","1","11","desktop:/steam.desktop","2","1","desktop:/System Control Panel.desktop","0","6","desktop:/Toggle Desktop Icons.desktop","1","3","desktop:/toggle-desktop-peek.desktop","2","4","desktop:/Toggle Open Apps.desktop","0","9","desktop:/trs80gp-frehd.desktop","2","7","desktop:/unimatrix-screensaver.desktop","1","8","desktop:/xscreensaver-settings.desktop","0","5","desktop:/yakuake.desktop"]}
sortMode=-1

[Containments][43][Wallpaper][org.kde.image][General]
Image=file:///run/media/duck/extra/User/Pictures/wallpapers_backup/It-Pc.png
SlidePaths=/home/duck/.local/share/wallpapers/,/usr/share/wallpapers/
EOF

# Apply the chaos to plasma config
awk -v temp="$temp_file" '
BEGIN { in_containment = 0; replaced = 0 }
/\[Containments\]/ { 
    if ($0 ~ /\[43\]/) {
        in_containment = 1
        print $0
        next
    }
}
in_containment && /\[.*\]/ && !/\[Containments\]/ {
    in_containment = 0
    print $0
    next
}
in_containment && /positions=/ {
    while ((getline line < temp) > 0) {
        print line
    }
    replaced = 1
    next
}
!in_containment { print }
END {
    if (!replaced) {
        print "Warning: positions line not found"
    }
}
' "$PLASMA_CONFIG" > "$PLASMA_CONFIG.new" && mv "$PLASMA_CONFIG.new" "$PLASMA_CONFIG"

rm "$temp_file"

echo -e "${GREEN}✅ Desktop chaos created!${NC}"
echo ""
echo -e "${RED}🎯 Your desktop icons should now be scrambled!${NC}"
echo ""
echo -e "${BLUE}🧪 Test the restoration tools:${NC}"
echo "   1. Open the HTML planner"
echo "   2. Try '🔄 Restart Plasma' button"
echo "   3. Try '🔄 Restore to Clean Layout' button"
echo "   4. Try '🚨 Emergency Reset' button"
echo ""
echo -e "${GREEN}💡 All tools should work to restore your desktop!${NC}"
echo ""
echo -e "${YELLOW}📋 Backup file: plasma-config-before-chaos-$TIMESTAMP.conf${NC}"
