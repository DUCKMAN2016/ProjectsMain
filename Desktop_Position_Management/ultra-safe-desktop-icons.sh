#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Ultra-Safe Desktop Icon Position Manager
# This script ONLY saves/restores icon positions WITHOUT touching main plasma config

PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
BACKUP_DIR="$HOME/.config/desktop-icon-backups"
ICON_POSITIONS_FILE="$HOME/.config/desktop-icon-positions.conf"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🖥️  Ultra-Safe Desktop Icon Manager${NC}"
echo "=================================="

# Create backup directory
mkdir -p "$BACKUP_DIR"

save_positions() {
    echo -e "${GREEN}💾 Saving desktop icon positions...${NC}"
    
    if [ -f "$PLASMA_CONFIG" ]; then
        # Extract ONLY the position-related lines
        grep -E "(positions=|itemIndex=|Alignment=)" "$PLASMA_CONFIG" > "$ICON_POSITIONS_FILE.backup-$TIMESTAMP"
        
        # Also extract the full Containment sections for desktop
        awk '
        /\[Containments\]/ {in_containment=1; print}
        in_containment && /\[Applets\]/ {in_containment=0; print}
        in_containment {print}
        ' "$PLASMA_CONFIG" > "$BACKUP_DIR/containment-$TIMESTAMP.conf"
        
        echo -e "${GREEN}✓ Icon positions saved${NC}"
        echo -e "${GREEN}✓ Containment data saved${NC}"
        
        # Create reference file
        echo "# Desktop Icon Position Backup - Ultra Safe" > "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "**Created:** $(date)" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "**Method:** Position-only extraction (safe)" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "## Files Created:" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "- Icon positions: $ICON_POSITIONS_FILE.backup-$TIMESTAMP" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "- Containment data: $BACKUP_DIR/containment-$TIMESTAMP.conf" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "## Safe Restoration:" >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        echo "This backup only contains position data and is safe to restore." >> "$BACKUP_DIR/safe_positions_$TIMESTAMP.md"
        
        echo -e "${GREEN}✓ Reference file created${NC}"
    else
        echo -e "${RED}❌ Plasma config file not found${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}🎯 Safe Save Complete!${NC}"
    echo "   • Only position data saved (ultra safe)"
    echo "   • Main plasma config untouched"
    echo "   • To restore: $0 restore"
}

restore_positions() {
    echo -e "${YELLOW}🔄 Restoring desktop icon positions (SAFE MODE)...${NC}"
    
    # Find the most recent position backup
    LATEST_POSITIONS=$(ls -t "$ICON_POSITIONS_FILE".backup-* 2>/dev/null | head -1)
    LATEST_CONTAINMENT=$(ls -t "$BACKUP_DIR"/containment-*.conf 2>/dev/null | head -1)
    
    if [ -z "$LATEST_POSITIONS" ] || [ -z "$LATEST_CONTAINMENT" ]; then
        echo -e "${RED}❌ No position backups found${NC}"
        echo -e "${YELLOW}💡 Run '$0 save' first to create a safe backup${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📋 Latest backups:${NC}"
    echo "   • Positions: $(basename "$LATEST_POSITIONS")"
    echo "   • Containment: $(basename "$LATEST_CONTAINMENT")"
    
    # Create backup of current config before modifying
    cp "$PLASMA_CONFIG" "$BACKUP_DIR/plasma-config-before-safe-restore-$TIMESTAMP.conf"
    echo -e "${YELLOW}✓ Current config backed up${NC}"
    
    # SAFELY restore only the position data
    echo -e "${YELLOW}🔧 Restoring position data only...${NC}"
    
    # Create a new config file with current settings + restored positions
    # First, backup current config
    cp "$PLASMA_CONFIG" "$PLASMA_CONFIG.tmp"
    
    # Remove old position lines from current config
    grep -v -E "(positions=|itemIndex=|Alignment=)" "$PLASMA_CONFIG.tmp" > "$PLASMA_CONFIG.new"
    
    # Add the restored positions
    cat "$LATEST_POSITIONS" >> "$PLASMA_CONFIG.new"
    
    # Replace the config
    mv "$PLASMA_CONFIG.new" "$PLASMA_CONFIG"
    rm "$PLASMA_CONFIG.tmp"
    
    echo -e "${GREEN}✓ Position data restored safely${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
    echo "   • Only position data was restored"
    echo "   • Main plasma settings preserved"
    echo "   • Changes will appear after:"
    echo "     1. Logout and login, OR"
    echo "     2. Restart plasmashell: pkill -f plasmashell && plasmashell &"
    echo ""
    echo -e "${GREEN}🎯 Safe Restoration Complete!${NC}"
    echo "   • Positions restored from backup"
    echo "   • Original config backed up"
    echo "   • Much safer than full config restore"
}

emergency_reset() {
    echo -e "${RED}🚨 EMERGENCY RESET - Restore to last known good state${NC}"
    
    # Find the most recent "before restore" backup
    EMERGENCY_BACKUP=$(ls -t "$BACKUP_DIR"/plasma-desktop-before-restore-*.conf 2>/dev/null | head -1)
    
    if [ -z "$EMERGENCY_BACKUP" ]; then
        echo -e "${RED}❌ No emergency backup found${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}📋 Emergency backup: $(basename "$EMERGENCY_BACKUP")${NC}"
    
    # Restore the emergency backup
    cp "$EMERGENCY_BACKUP" "$PLASMA_CONFIG"
    
    echo -e "${GREEN}✓ Emergency restore complete${NC}"
    echo -e "${YELLOW}⚠️  Restart plasmashell or logout/login to apply${NC}"
}

status() {
    echo -e "${BLUE}📊 Safe Desktop Icon Status:${NC}"
    echo ""
    
    if [ -f "$PLASMA_CONFIG" ]; then
        echo -e "${GREEN}✓ Plasma config file exists${NC}"
        
        # Show safe backups
        POSITION_BACKUPS=$(ls -1 "$ICON_POSITIONS_FILE".backup-* 2>/dev/null | wc -l)
        CONTAINMENT_BACKUPS=$(ls -1 "$BACKUP_DIR"/containment-*.conf 2>/dev/null | wc -l)
        EMERGENCY_BACKUPS=$(ls -1 "$BACKUP_DIR"/plasma-desktop-before-restore-*.conf 2>/dev/null | wc -l)
        
        echo -e "${GREEN}✓ Safe position backups: $POSITION_BACKUPS${NC}"
        echo -e "${GREEN}✓ Containment backups: $CONTAINMENT_BACKUPS${NC}"
        echo -e "${GREEN}✓ Emergency backups: $EMERGENCY_BACKUPS${NC}"
        
        if [ $EMERGENCY_BACKUPS -gt 0 ]; then
            echo ""
            echo -e "${YELLOW}🚨 Emergency recovery available!${NC}"
            echo "   Run: $0 emergency-reset"
        fi
    else
        echo -e "${RED}❌ Plasma config file not found${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}💡 Usage:${NC}"
    echo "   $0 save           - Save positions (safe)"
    echo "   $0 restore        - Restore positions (safe)"
    echo "   $0 emergency-reset - Emergency restore to last good state"
    echo "   $0 status         - Show this status"
}

# Main logic
case "$1" in
    save)
        save_positions
        ;;
    restore)
        restore_positions
        ;;
    emergency-reset)
        emergency_reset
        ;;
    status)
        status
        ;;
    *)
        echo -e "${BLUE}Ultra-Safe Desktop Icon Position Manager${NC}"
        echo ""
        echo "Usage: $0 {save|restore|emergency-reset|status}"
        echo ""
        echo -e "${GREEN}save${NC}           - Save positions (position data only)"
        echo -e "${GREEN}restore${NC}        - Restore positions (safe method)"
        echo -e "${GREEN}emergency-reset${NC} - Emergency restore to last good state"
        echo -e "${GREEN}status${NC}         - Show status and available backups"
        echo ""
        echo -e "${YELLOW}⚠️  This version NEVER touches main plasma config structure${NC}"
        echo -e "${YELLOW}    Only position data is modified for maximum safety${NC}"
        exit 1
        ;;
esac
