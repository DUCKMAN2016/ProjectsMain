#!/bin/bash

# Open MAME settings directory in file manager
# This allows easy access to MAME configuration files

MAME_DIR="$HOME/.mame"

# Create the directory if it doesn't exist
mkdir -p "$MAME_DIR"

# Try to open with Dolphin (KDE file manager)
if command -v dolphin &> /dev/null; then
    dolphin "$MAME_DIR" &
# Fallback to other file managers
elif command -v nautilus &> /dev/null; then
    nautilus "$MAME_DIR" &
elif command -v thunar &> /dev/null; then
    thunar "$MAME_DIR" &
else
    # If no GUI file manager, open in terminal with nano
    konsole --noclose -e bash -c "cd $MAME_DIR && nano mame.ini || vim mame.ini || less mame.ini"
fi

echo "Opened MAME settings directory: $MAME_DIR"
