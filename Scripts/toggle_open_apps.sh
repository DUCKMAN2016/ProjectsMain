#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Simple toggle open apps - just toggle windows
WINDOW_STATE_FILE="$HOME/.toggle_apps_state"

# Check current state
if [ -f "$WINDOW_STATE_FILE" ]; then
    # Currently minimized - restore windows
    echo "Restoring windows..."
    wmctrl -k off 2>/dev/null
    sleep 0.5  # Small delay to ensure command completes
    rm -f "$WINDOW_STATE_FILE"
    echo "✓ Windows restored"
else
    # Currently normal - minimize windows
    echo "Minimizing windows..."
    wmctrl -k on 2>/dev/null
    sleep 0.5  # Small delay to ensure command completes
    touch "$WINDOW_STATE_FILE"
    echo "✓ Windows minimized"
fi

# Add delay to prevent rapid re-execution
sleep 1
