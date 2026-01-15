#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Safe Desktop Icon Position Management
# This script saves/restores desktop icon positions WITHOUT restarting plasmashell

PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
BACKUP_DIR="$HOME/.config/desktop-icon-backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🖥️  Safe Desktop Icon Position Manager${NC}"
echo "=================================="

# Create backup directory
mkdir -p "$BACKUP_DIR"

save_positions() {
    echo -e "${GREEN}💾 Saving current desktop icon positions...${NC}"
    
    # Backup the entire plasma config
    cp "$PLASMA_CONFIG" "$BACKUP_DIR/plasma-desktop-backup-$TIMESTAMP.conf"
    
    # Extract just the position data
    if [ -f "$PLASMA_CONFIG" ]; then
        # Extract Containment positions
        grep -A 100 "\[Containments\]" "$PLASMA_CONFIG" | grep -B 100 "\[Containments\]\|\[Applets\]" | grep -E "(position|Alignment|itemIndex)" > "$BACKUP_DIR/positions-$TIMESTAMP.txt"
        
        echo -e "${GREEN}✓ Positions saved to backup-$TIMESTAMP.conf${NC}"
        echo -e "${GREEN}✓ Position data extracted to positions-$TIMESTAMP.txt${NC}"
        
        # Create a simple reference file
        echo "# Desktop Icon Position Backup" > "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "**Created:** $(date)" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "**Backup File:** plasma-desktop-backup-$TIMESTAMP.conf" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "## Restoration Instructions:" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "1. Copy the backup file to: $PLASMA_CONFIG" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "2. Logout and login again (or restart plasmashell)" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        echo "⚠️  **IMPORTANT:** Always logout before restarting to ensure proper restoration" >> "$BACKUP_DIR/desktop_positions_$TIMESTAMP.md"
        
        echo -e "${GREEN}✓ Reference file created: desktop_positions_$TIMESTAMP.md${NC}"
    else
        echo -e "${RED}❌ Plasma config file not found: $PLASMA_CONFIG${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}🎯 Save Complete!${NC}"
    echo "   • Backup stored in: $BACKUP_DIR/"
    echo "   • To restore: $0 restore"
    echo "   • Or manually logout/login after restore"
}

restore_positions() {
    echo -e "${YELLOW}🔄 Restoring desktop icon positions...${NC}"
    
    # Find the most recent backup
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/plasma-desktop-backup-*.conf 2>/dev/null | head -1)
    
    if [ -z "$LATEST_BACKUP" ]; then
        echo -e "${RED}❌ No backup files found in $BACKUP_DIR${NC}"
        echo -e "${YELLOW}💡 Run '$0 save' first to create a backup${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📋 Latest backup: $(basename "$LATEST_BACKUP")${NC}"
    
    # Create a backup of current config before restoring
    if [ -f "$PLASMA_CONFIG" ]; then
        cp "$PLASMA_CONFIG" "$BACKUP_DIR/plasma-desktop-before-restore-$TIMESTAMP.conf"
        echo -e "${YELLOW}✓ Current config backed up${NC}"
    fi
    
    # Restore the backup WITHOUT restarting plasmashell
    echo -e "${YELLOW}🔧 Restoring plasma configuration...${NC}"
    cp "$LATEST_BACKUP" "$PLASMA_CONFIG"
    
    echo -e "${GREEN}✓ Configuration restored${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANT: Changes will take effect after:${NC}"
    echo "   1. Logout and login again, OR"
    echo "   2. Restart plasmashell manually (kquitapp6 plasmashell && plasmashell &)"
    echo "   3. Or use: pkill -f plasmashell && plasmashell &"
    echo ""
    echo -e "${GREEN}🎯 Restoration Complete!${NC}"
    echo "   • Config restored from: $(basename "$LATEST_BACKUP")"
    echo "   • Current config backed up to: plasma-desktop-before-restore-$TIMESTAMP.conf"
    echo "   • Changes will appear after logout/login or plasmashell restart"
}

status() {
    echo -e "${BLUE}📊 Desktop Icon Position Status:${NC}"
    echo ""
    
    if [ -f "$PLASMA_CONFIG" ]; then
        echo -e "${GREEN}✓ Plasma config file exists${NC}"
        echo "   Location: $PLASMA_CONFIG"
        
        # Count desktop items
        DESKTOP_ITEMS=$(find "$HOME/Desktop" -maxdepth 1 -name "*.desktop" | wc -l)
        echo -e "${GREEN}✓ Desktop items: $DESKTOP_ITEMS${NC}"
        
        # Show recent backups
        BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/plasma-desktop-backup-*.conf 2>/dev/null | wc -l)
        echo -e "${GREEN}✓ Available backups: $BACKUP_COUNT${NC}"
        
        if [ $BACKUP_COUNT -gt 0 ]; then
            echo ""
            echo -e "${BLUE}📁 Recent backups:${NC}"
            ls -lt "$BACKUP_DIR"/plasma-desktop-backup-*.conf | head -3 | while read line; do
                filename=$(echo "$line" | awk '{print $9}')
                timestamp=$(echo "$line" | awk '{print $6, $7, $8}')
                echo "   • $(basename "$filename") - $timestamp"
            done
        fi
    else
        echo -e "${RED}❌ Plasma config file not found${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}💡 Usage:${NC}"
    echo "   $0 save    - Save current positions"
    echo "   $0 restore - Restore from backup"
    echo "   $0 status  - Show this status"
}

# Main logic
case "$1" in
    save)
        save_positions
        ;;
    restore)
        restore_positions
        ;;
    status)
        status
        ;;
    *)
        echo -e "${BLUE}Safe Desktop Icon Position Manager${NC}"
        echo ""
        echo "Usage: $0 {save|restore|status}"
        echo ""
        echo -e "${GREEN}save${NC}     - Save current desktop icon positions"
        echo -e "${GREEN}restore${NC}  - Restore positions from backup (SAFE - no restart)"
        echo -e "${GREEN}status${NC}   - Show current status and available backups"
        echo ""
        echo -e "${YELLOW}⚠️  This version does NOT restart plasmashell automatically${NC}"
        echo -e "${YELLOW}    Changes take effect after logout/login or manual restart${NC}"
        exit 1
        ;;
esac
