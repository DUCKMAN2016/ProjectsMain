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

echo -e "${BLUE}🔄 Restarting Plasma Shell...${NC}"
echo ""

# Kill plasmashell
echo -e "${YELLOW}🔨 Killing plasmashell...${NC}"
pkill -f plasmashell

# Wait for process to fully terminate
echo -e "${YELLOW}⏳ Waiting 3 seconds...${NC}"
sleep 3

# Start plasmashell in background
echo -e "${YELLOW}🚀 Starting plasmashell...${NC}"
nohup plasmashell > /dev/null 2>&1 &

echo -e "${GREEN}✅ Plasma shell restarted${NC}"
echo -e "${BLUE}🖥️ Desktop should be loading...${NC}"
echo -e "${GREEN}📝 Script completed - prompt returned${NC}"
