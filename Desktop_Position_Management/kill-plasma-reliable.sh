#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}💀 Killing Plasma Shell...${NC}"
echo ""

# Kill plasmashell
echo -e "${YELLOW}🔨 Executing: pkill -f plasmashell${NC}"
pkill -f plasmashell

echo -e "${YELLOW}⏳ Waiting 3 seconds...${NC}"
sleep 3

# Try multiple methods to restart plasmashell
echo -e "${YELLOW}🚀 Attempting to restart plasmashell...${NC}"

# Method 1: Direct start
echo -e "${YELLOW}📋 Method 1: Direct start${NC}"
plasmashell &
sleep 2

# Method 2: Check if running, if not try kwin_wayland wrapper
if ! pgrep -f plasmashell > /dev/null; then
    echo -e "${YELLOW}📋 Method 2: KDE restart${NC}"
    kquitapp6 plasmashell 2>/dev/null
    sleep 2
    plasmashell &
    sleep 2
fi

# Method 3: If still not running, try dbus method
if ! pgrep -f plasmashell > /dev/null; then
    echo -e "${YELLOW}📋 Method 3: DBUS method${NC}"
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.show 2>/dev/null &
    sleep 2
fi

# Check if plasmashell is running
if pgrep -f plasmashell > /dev/null; then
    echo -e "${GREEN}✅ Plasma shell is running${NC}"
    echo -e "${BLUE}🖥️ Desktop should be loading...${NC}"
else
    echo -e "${RED}❌ Plasma shell failed to start${NC}"
    echo -e "${YELLOW}💡 Try running: plasmashell &${NC}"
    echo -e "${YELLOW}💡 Or restart your session${NC}"
fi

echo -e "${GREEN}📝 Script completed${NC}"
