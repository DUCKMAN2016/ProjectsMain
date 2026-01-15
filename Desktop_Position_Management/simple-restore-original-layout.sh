#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Simple Desktop Icon Restoration Using Working Backup
# Uses the known working backup from 3:04 PM

PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
BACKUP_DIR="$HOME/.config/desktop-icon-backups"
WORKING_BACKUP="$BACKUP_DIR/plasma-desktop-backup-20260114-150406.conf"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Simple Desktop Icon Restoration${NC}"
echo "=================================="
echo ""

# Check if working backup exists
if [ ! -f "$WORKING_BACKUP" ]; then
    echo -e "${YELLOW}⚠️  Specific backup not found, using most recent${NC}"
    
    # Find the most recent backup
    WORKING_BACKUP=$(ls -t "$BACKUP_DIR"/plasma-desktop-backup-*.conf 2>/dev/null | head -1)
    
    if [ -z "$WORKING_BACKUP" ]; then
        echo -e "${RED}❌ No backups found in $BACKUP_DIR${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Found backup: $(basename "$WORKING_BACKUP")${NC}"
echo -e "${BLUE}📁 Using most recent available backup${NC}"

# Backup current state
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
cp "$PLASMA_CONFIG" "$BACKUP_DIR/plasma-config-before-simple-restore-$TIMESTAMP.conf"
echo -e "${GREEN}✓ Current state backed up${NC}"

# Restore the working backup
echo -e "${YELLOW}🔧 Restoring from working backup...${NC}"
cp "$WORKING_BACKUP" "$PLASMA_CONFIG"

echo -e "${GREEN}✅ Restoration complete!${NC}"
echo ""
echo -e "${BLUE}📋 This will restore your desktop to:${NC}"
echo "   • 3 rows of icons (original layout)"
echo "   • Row 1: 12 icons (btop → Ms. Pac-Man)"
echo "   • Row 2: 12 icons (MYZ80 → Steam)"
echo "   • Row 3: 8 icons (System Control Panel → Yakuake)"
echo ""
echo -e "${YELLOW}⚠️  Restart plasmashell to apply changes:${NC}"
echo "   pkill -f plasmashell && sleep 2 && plasmashell &"
echo ""
echo -e "${GREEN}🎯 This method uses a known working backup!${NC}"
