#!/bin/bash
# Script to update Windsurf AI editor
# Supports both AUR package updates and manual tarball installation
# Created by Cascade AI

echo "=== Windsurf AI Editor Update Script ==="
echo ""

# Function to update via AUR
update_via_aur() {
    echo "Checking for Windsurf updates via AUR..."
    
    # Check current version
    CURRENT_VERSION=$(yay -Qi windsurf 2>/dev/null | grep "^Version" | awk '{print $3}')
    
    if [ -z "$CURRENT_VERSION" ]; then
        echo "Windsurf is not installed via AUR. Use manual installation instead."
        return 1
    fi
    
    echo "Current version: $CURRENT_VERSION"
    
    # Check available version
    AVAILABLE_VERSION=$(yay -Si windsurf 2>/dev/null | grep "^Version" | awk '{print $3}')
    echo "Available version: $AVAILABLE_VERSION"
    echo ""
    
    if [ "$CURRENT_VERSION" = "$AVAILABLE_VERSION" ]; then
        echo "Windsurf is already up to date!"
        check_downloads_for_newer_version
        return 0
    fi
    
    echo "Updating Windsurf from $CURRENT_VERSION to $AVAILABLE_VERSION..."
    echo "NOTE: Please close Windsurf before proceeding!"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to cancel..."
    
    yay -S windsurf --noconfirm
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "=== Update Complete ==="
        NEW_VERSION=$(yay -Qi windsurf 2>/dev/null | grep "^Version" | awk '{print $3}')
        echo "Windsurf has been updated to version $NEW_VERSION"
        echo "You can now launch Windsurf from your applications menu or by typing 'windsurf' in the terminal."
        check_downloads_for_newer_version
        exit 0
    else
        echo "Update failed. Please check the error messages above."
        return 1
    fi
}

# Function to install from tarball
install_from_tarball() {
    TARBALL_PATH="$1"
    
    # Check if the tarball exists and is readable
    if [ ! -f "$TARBALL_PATH" ]; then
        echo "Error: Tarball file not found at $TARBALL_PATH"
        return 1
    fi
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    
    echo "Extracting Windsurf AI editor from $TARBALL_PATH..."
    tar -xzf "$TARBALL_PATH" -C "$TEMP_DIR"
    
    if [ $? -ne 0 ]; then
        echo "Failed to extract Windsurf AI editor."
        rm -rf "$TEMP_DIR"
        return 1
    fi
    
    # Install Windsurf AI editor
    echo "Installing Windsurf AI editor..."
    sudo cp -r "$TEMP_DIR/Windsurf" /opt/
    sudo ln -sf /opt/Windsurf/windsurf /usr/local/bin/windsurf
    
    if [ $? -ne 0 ]; then
        echo "Failed to install Windsurf AI editor."
        rm -rf "$TEMP_DIR"
        return 1
    fi
    
    # Create desktop entry
    echo "Creating desktop entry..."
    DESKTOP_ENTRY="$HOME/.local/share/applications/windsurf.desktop"
    mkdir -p "$(dirname "$DESKTOP_ENTRY")"
    
    cat > "$DESKTOP_ENTRY" << EOF
[Desktop Entry]
Name=Windsurf AI Editor
Comment=AI-powered code editor
Exec=/opt/Windsurf/windsurf %F
Icon=/opt/Windsurf/resources/app/resources/linux/code.png
Type=Application
Categories=Development;IDE;TextEditor;
MimeType=text/plain;inode/directory;application/x-code-workspace;
StartupNotify=true
StartupWMClass=Windsurf
Keywords=windsurf;editor;code;ai;development;
EOF
    
    chmod +x "$DESKTOP_ENTRY"
    update-desktop-database "$HOME/.local/share/applications"
    
    echo ""
    echo "=== Installation Complete ==="
    echo "Windsurf AI editor has been installed."
    echo "You can now launch it by typing 'windsurf' in the terminal or from your applications menu."
    
    # Clean up
    rm -rf "$TEMP_DIR"
    exit 0
}

# Function to check Downloads for newer Windsurf tarball
check_downloads_for_newer_version() {
    DOWNLOAD_DIR="$HOME/Downloads"
    
    if [ ! -d "$DOWNLOAD_DIR" ]; then
        return
    fi
    
    CURRENT_VERSION=$(yay -Qi windsurf 2>/dev/null | grep "^Version" | awk '{print $3}')
    
    if [ -z "$CURRENT_VERSION" ]; then
        echo "Cannot determine current version."
        return
    fi
    
    LATEST_FILE=""
    LATEST_VERSION=""
    
    for file in "$DOWNLOAD_DIR"/Windsurf*.tar.gz; do
        if [ ! -f "$file" ]; then
            continue
        fi
        
        # Extract version from filename, assuming Windsurf-linux-x64-{version}.tar.gz
        basename_file=$(basename "$file")
        version=$(echo "$basename_file" | sed 's/^Windsurf-linux-x64-//;s/\.tar\.gz$//')
        
        if [ -z "$version" ]; then
            continue
        fi
        
        if [ -z "$LATEST_VERSION" ] || [ $(vercmp "$version" "$LATEST_VERSION") -gt 0 ]; then
            LATEST_VERSION="$version"
            LATEST_FILE="$file"
        fi
    done
    
    if [ -z "$LATEST_FILE" ]; then
        return
    fi
    
    if [ $(vercmp "$LATEST_VERSION" "$CURRENT_VERSION") -gt 0 ]; then
        echo "Found newer version $LATEST_VERSION in Downloads ($LATEST_FILE)"
        read -p "Install from this tarball? (y/n): " choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
            install_from_tarball "$LATEST_FILE"
            exit 0
        fi
    fi
}

# Main script logic
if [ $# -eq 0 ]; then
    # No arguments - try AUR update
    update_via_aur
elif [ $# -eq 1 ]; then
    # One argument - install from tarball
    echo "Installing from tarball: $1"
    echo ""
    install_from_tarball "$1"
else
    echo "Usage:"
    echo "  $0                          # Update via AUR (recommended)"
    echo "  $0 <path_to_tarball>        # Install from local tarball"
    echo ""
    echo "Example: $0 ~/Downloads/Windsurf-linux-x64-1.12.36.tar.gz"
    exit 1
fi
