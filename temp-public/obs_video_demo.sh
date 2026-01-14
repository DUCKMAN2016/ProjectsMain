#!/bin/bash

# OBS Video Demo Script - Automated KDE Desktop Tools Demonstration
# Run this script in OBS while recording to create the YouTube video automatically
# Each demo includes timed pauses and visual cues for editing

set -e

# Configuration
DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/kde_tools_demo.log"
NOTIFY_DELAY=2
DEMO_DELAY=3

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

# Notification function
notify() {
    notify-send "KDE Tools Demo" "$1" -t 3000 2>/dev/null || echo "NOTIFY: $1"
}

# Countdown function
countdown() {
    local seconds=$1
    local message=$2
    
    log "COUNTDOWN: $message in $seconds seconds..."
    notify "$message in $seconds seconds..."
    
    for ((i=seconds; i>0; i--)); do
        echo -ne "\r${YELLOW}⏱️  $i...${NC}"
        sleep 1
    done
    echo -e "\r${GREEN}✅ GO!${NC}\n"
}

# Section header
section() {
    local title=$1
    local duration=$2
    
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}🎬 SECTION: $title${NC}"
    echo -e "${BLUE}⏱️  Duration: $duration seconds${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"
    
    log "STARTING SECTION: $title"
    notify "Starting: $title"
}

# Demo function with timing
demo_step() {
    local action=$1
    local duration=$2
    local description=$3
    
    log "DEMO: $action ($duration sec) - $description"
    notify "$action"
    
    echo -e "${GREEN}🎥 ACTION: $action${NC}"
    echo -e "${YELLOW}⏱️  Duration: $duration seconds${NC}"
    echo -e "${BLUE}📝 Description: $description${NC}\n"
    
    countdown $duration "Perform: $description"
}

# Clear desktop function
clear_desktop() {
    log "Clearing desktop for demo..."
    # Close any open windows
    wmctrl -l | while read window; do
        wmctrl -c "$(echo $window | cut -d' ' -f1)" 2>/dev/null || true
    done
    sleep 1
}

# Create demo files on desktop
create_demo_files() {
    log "Creating demo files on desktop..."
    mkdir -p "$HOME/Desktop"
    
    # Create some demo files
    for i in {1..8}; do
        touch "$HOME/Desktop/Demo_File_$i.txt"
        echo "Demo file $i content" > "$HOME/Desktop/Demo_File_$i.txt"
    done
    
    # Create some folders
    for i in {1..3}; do
        mkdir -p "$HOME/Desktop/Demo_Folder_$i"
        touch "$HOME/Desktop/Demo_Folder_$i/note.txt"
    done
    
    log "Demo files created"
}

# Open demo windows
open_demo_windows() {
    log "Opening demo windows..."
    
    # Open some terminal windows
    konsole &>/dev/null &
    sleep 0.5
    konsole &>/dev/null &
    sleep 0.5
    
    # Open file manager
    dolphin "$HOME" &>/dev/null &
    sleep 0.5
    
    # Open text editor
    kate &>/dev/null &
    sleep 1
    
    log "Demo windows opened"
}

# Main demo starts here
echo -e "${BLUE}🎬 KDE DESKTOP TOOLS - AUTOMATED OBS DEMO SCRIPT${NC}"
echo -e "${BLUE}===============================================${NC}\n"

log "Starting automated KDE Desktop Tools demo for OBS recording"
notify "Starting KDE Tools Demo - Press Ctrl+C to stop"

# Check dependencies
for cmd in wmctrl xdotool notify-send kdialog konsole dolphin kate; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${RED}❌ Missing dependency: $cmd${NC}"
        echo -e "${RED}Please install: sudo pacman -S wmctrl xdotool libnotify kde-cli-tools konsole dolphin kate${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✅ All dependencies found!${NC}\n"

# === INTRODUCTION SECTION ===
section "INTRODUCTION - The Problem" 30

demo_step "Show messy desktop" 10 "Display cluttered desktop with icons and windows"
create_demo_files
open_demo_windows
demo_step "Highlight the mess" 20 "Point out scattered icons and windows with cursor"

# === SOLUTION PREVIEW ===
section "SOLUTION PREVIEW" 30

demo_step "Show GitHub repo" 10 "Display the GitHub repository in browser"
demo_step "Show folder structure" 10 "Display the organized tool folders"
demo_step "Preview all tools" 10 "Quick montage of what's coming"

# === INSTALLATION ===
section "INSTALLATION" 60

demo_step "Open terminal" 5 "Open Konsole terminal window"
demo_step "Clone repository" 15 "Type: git clone https://github.com/DUCKMAN2016/Arch---Helper-Scripts.git"
demo_step "Change directory" 10 "Type: cd \"Arch - Helper Scripts\""
demo_step "Run installer" 20 "Type: ./install.sh and show the output"
demo_step "Show launchers" 10 "Display new launchers in application menu"

# === DESKTOP PEEK SUITE ===
section "DESKTOP PEEK SUITE - Main Feature" 90

demo_step "Show current mess" 10 "Display the messy desktop again"
demo_step "Launch Desktop Peek" 10 "Click desktop_peek_unified.sh launcher"
demo_step "Show transformation" 15 "Watch icons disappear and windows minimize"
demo_step "Show notification" 10 "Highlight the notification popup"
demo_step "Admire clean desktop" 15 "Show the perfectly clean desktop"
demo_step "Restore everything" 10 "Click Desktop Peek again"
demo_step "Show restoration" 15 "Watch everything come back perfectly"
demo_step "Multi-monitor demo" 5 "Show it works on multiple monitors"

# === SYSTEM CONTROL PANEL ===
section "SYSTEM CONTROL PANEL" 90

demo_step "Launch control panel" 10 "Start system_control_panel.sh"
demo_step "Show GUI interface" 15 "Display the beautiful kdialog window"
demo_step "Demonstrate power controls" 20 "Show shutdown, reboot, logout buttons"
demo_step "Demonstrate desktop controls" 20 "Show toggle icons, refresh, peek buttons"
demo_step "Show customization" 15 "Display script with TODO comments"
demo_step "Close panel" 10 "Close the control panel"

# === UTILITY TOOLS ===
section "UTILITY TOOLS" 90

demo_step "Audio Switcher demo" 20 "Run switch-audio.sh and show device selection"
demo_step "Window Center demo" 20 "Open a window and run center-mame-window.sh"
demo_step "Icon Toggle demo" 15 "Run toggle_desktop_icons.sh"
demo_step "Desktop Refresh demo" 15 "Run refresh-desktop.sh"
demo_step "Show all utilities" 20 "Quick recap of all utility tools"

# === CONCLUSION ===
section "CONCLUSION & CALL TO ACTION" 30

demo_step "Show GitHub repo again" 10 "Display repository in browser"
demo_step "Show star button" 5 "Highlight the star button on GitHub"
demo_step "Show subscribe animation" 5 "Display subscribe button animation"
demo_step "Final tools showcase" 5 "Quick montage of all tools working"
demo_step "End screen" 5 "Show channel end screen with subscribe button"

# === CLEANUP ===
section "CLEANUP" 30

demo_step "Close all windows" 10 "Close all demo windows and applications"
demo_step "Clean desktop files" 10 "Remove demo files from desktop"
demo_step "Final clean desktop" 10 "Show perfectly clean desktop"

# Completion message
echo -e "\n${GREEN}🎉 DEMO COMPLETE!${NC}"
echo -e "${GREEN}==================${NC}\n"

log "Automated demo completed successfully"
notify "Demo Complete! Stop recording in OBS"

echo -e "${BLUE}📊 Demo Statistics:${NC}"
echo -e "${BLUE}• Total duration: ~6 minutes${NC}"
echo -e "${BLUE}• Sections completed: 6${NC}"
echo -e "${BLUE}• Tools demonstrated: 10${NC}"
echo -e "${BLUE}• Log file: $LOG_FILE${NC}\n"

echo -e "${YELLOW}🎬 Next steps for YouTube:${NC}"
echo -e "${YELLOW}1. Add voiceover commentary${NC}"
echo -e "${YELLOW}2. Add zoom effects and highlights${NC}"
echo -e "${YELLOW}3. Add background music${NC}"
echo -e "${YELLOW}4. Create thumbnail and description${NC}"
echo -e "${YELLOW}5. Upload to YouTube!${NC}\n"

echo -e "${GREEN}✅ Ready for YouTube production!${NC}"
