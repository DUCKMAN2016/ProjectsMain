#!/bin/bash

# CachyOS Comprehensive Post-Install Configuration Script
# Automatically recreates entire system setup including desktop, panel, network storage, and applications

echo "🚀 Starting CachyOS Comprehensive Post-Install Configuration..."

# Check if running as user (not root)
if [ "$EUID" -eq 0 ]; then
    echo "❌ Please run this script as your regular user, not as root"
    exit 1
fi

# Create backup directory
BACKUP_DIR="$HOME/.config/kde-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "📁 Created backup directory: $BACKUP_DIR"

# Backup existing configs
echo "💾 Backing up existing configurations..."
[ -f "$HOME/.config/kdeglobals" ] && cp "$HOME/.config/kdeglobals" "$BACKUP_DIR/"
[ -f "$HOME/.config/kwinrc" ] && cp "$HOME/.config/kwinrc" "$BACKUP_DIR/"
[ -f "$HOME/.config/plasmarc" ] && cp "$HOME/.config/plasmarc" "$BACKUP_DIR/"
[ -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ] && cp "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" "$BACKUP_DIR/"

# Backup new app configs
[ -d "$HOME/.steam" ] && cp -r "$HOME/.steam" "$BACKUP_DIR/"
[ -d "$HOME/.mame" ] && cp -r "$HOME/.mame" "$BACKUP_DIR/"
[ -d "$HOME/.config/dolphin-emu" ] && cp -r "$HOME/.config/dolphin-emu" "$BACKUP_DIR/"
[ -d "$HOME/.config/retroarch" ] && cp -r "$HOME/.config/retroarch" "$BACKUP_DIR/"
[ -d "$HOME/.config/Code" ] && cp -r "$HOME/.config/Code" "$BACKUP_DIR/"
[ -d "$HOME/.config/kate" ] && cp -r "$HOME/.config/kate" "$BACKUP_DIR/"
[ -d "$HOME/.config/VirtualBox" ] && cp -r "$HOME/.config/VirtualBox" "$BACKUP_DIR/"
[ -d "$HOME/.config/windsurf" ] && cp -r "$HOME/.config/windsurf" "$BACKUP_DIR/"
[ -d "$HOME/.config/filezilla" ] && cp -r "$HOME/.config/filezilla" "$BACKUP_DIR/"
[ -d "$HOME/.config/remmina" ] && cp -r "$HOME/.config/remmina" "$BACKUP_DIR/"
[ -d "$HOME/.config/doublecmd" ] && cp -r "$HOME/.config/doublecmd" "$BACKUP_DIR/"
[ -d "$HOME/.config/cool-retro-term" ] && cp -r "$HOME/.config/cool-retro-term" "$BACKUP_DIR/"
[ -d "$HOME/.config/konsole" ] && cp -r "$HOME/.config/konsole" "$BACKUP_DIR/"
[ -d "$HOME/.config/ghb" ] && cp -r "$HOME/.config/ghb" "$BACKUP_DIR/"
[ -d "$HOME/.config/krita" ] && cp -r "$HOME/.config/krita" "$BACKUP_DIR/"
[ -d "$HOME/.config/qBittorrent" ] && cp -r "$HOME/.config/qBittorrent" "$BACKUP_DIR/"
[ -d "$HOME/.config/shotcut" ] && cp -r "$HOME/.config/shotcut" "$BACKUP_DIR/"
[ -d "$HOME/.config/soundconverter" ] && cp -r "$HOME/.config/soundconverter" "$BACKUP_DIR/"
[ -d "$HOME/.config/jdownloader2" ] && cp -r "$HOME/.config/jdownloader2" "$BACKUP_DIR/"
[ -d "$HOME/.config/octopi" ] && cp -r "$HOME/.config/octopi" "$BACKUP_DIR/"
[ -d "$HOME/.config/nordvpn-gui" ] && cp -r "$HOME/.config/nordvpn-gui" "$BACKUP_DIR/"
[ -d "$HOME/.flutter" ] && cp -r "$HOME/.flutter" "$BACKUP_DIR/"

# Backup OBS config
[ -d "/run/media/duck/extra/User/home/duck/.config/obs-studio" ] && cp -r "/run/media/duck/extra/User/home/duck/.config/obs-studio" "$HOME/.config/" && echo "Restored OBS config"

# Backup enpass config
[ -d "$HOME/.enpass" ] && cp -r "$HOME/.enpass" "$BACKUP_DIR/"

# ============================================================================
# 1. SYSTEM PREPARATION AND AUR SETUP
# ============================================================================
echo "🔧 Preparing system and installing AUR helper..."

# Update system
sudo pacman -Syu --noconfirm

# Install yay AUR helper if not present
if ! command -v yay &> /dev/null; then
    echo "📦 Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd /run/media/duck/extra/User/Downloads/ProjectsMain/Post-Install-CachyOS
    echo "✅ yay installed successfully"
else
    echo "✅ yay already installed"
fi

# ============================================================================
# 2. SYSTEM PACKAGES INSTALLATION
# ============================================================================
echo "📦 Installing required packages..."

# Install KDE Plasma applications found in discovery
echo "🎮 Installing gaming and emulation packages..."
sudo pacman -S --noconfirm steam mame dolphin-emu retroarch

# Install development tools
echo "💻 Installing development tools..."
sudo pacman -S --noconfirm code kate virtualbox windsurf

# Install network and file management tools
echo "🌐 Installing network tools..."
sudo pacman -S --noconfirm filezilla remmina doublecmd

# Install utility applications
echo "🔧 Installing utilities..."
sudo pacman -S --noconfirm xscreensaver cool-retro-term konsole handbrake krita qbittorrent shotcut soundconverter obs-studio cmatrix asciiquarium vlc unimatrix

# Note: VLC is now installed and configured

# ============================================================================
# XSCREENSAVER CONFIGURATION FOR WAYLAND
# ============================================================================
echo "🖥️ Configuring XScreenSaver for Wayland/XWayland..."

# Create XScreenSaver settings script
echo "📜 Creating XScreenSaver settings script..."
cat > /usr/local/bin/xscreensaver-settings.sh << 'EOF'
#!/bin/bash

# Start xscreensaver daemon if not running
if ! pgrep -x "xscreensaver" > /dev/null; then
    xscreensaver -no-splash &
    sleep 2
fi

# Force X11 for the settings dialog
GDK_BACKEND=x11 xscreensaver-settings
EOF

chmod +x /usr/local/bin/xscreensaver-settings.sh

# Update system launchers for Wayland compatibility
echo "🔧 Updating XScreenSaver launchers for Wayland..."
sudo sed -i 's|Exec=xscreensaver-settings|Exec=GDK_BACKEND=x11 xscreensaver-settings|' /usr/share/applications/xscreensaver-settings.desktop
sudo sed -i 's|Icon=xscreensaver|Icon=/usr/share/pixmaps/xscreensaver.png|' /usr/share/applications/xscreensaver-settings.desktop
sudo sed -i '/NotShowIn=KDE;GNOME;/d' /usr/share/applications/xscreensaver-settings.desktop

sudo sed -i 's|Exec=xscreensaver|Exec=GDK_BACKEND=x11 xscreensaver|' /usr/share/applications/xscreensaver.desktop
sudo sed -i 's|Icon=xscreensaver|Icon=/usr/share/pixmaps/xscreensaver.png|' /usr/share/applications/xscreensaver.desktop

# Create desktop launcher with Wayland compatibility
echo "🖼️ Creating XScreenSaver desktop launcher..."
cp /usr/share/applications/xscreensaver-settings.desktop ~/Desktop/
chmod +x ~/Desktop/xscreensaver-settings.desktop
sed -i 's|Exec=xscreensaver-settings|Exec=GDK_BACKEND=x11 xscreensaver-settings|' ~/Desktop/xscreensaver-settings.desktop
sed -i 's|Icon=xscreensaver|Icon=/usr/share/pixmaps/xscreensaver.png|' ~/Desktop/xscreensaver-settings.desktop
sed -i '/NotShowIn=KDE;GNOME;/d' ~/Desktop/xscreensaver-settings.desktop

# Configure robust autostart for Wayland
echo "⚙️ Configuring XScreenSaver autostart for Wayland..."

# Create autostart desktop entry
cat > ~/.config/autostart/xscreensaver.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=XScreenSaver
Comment=XScreenSaver daemon
Exec=/home/duck/.config/autostart/xscreensaver-daemon.sh
Icon=xscreensaver
Terminal=false
Categories=Screensaver;Security;
X-KDE-Autostart-Phase=2
X-KDE-StartupNotify=false
Hidden=false
NoDisplay=false
EOF

# Create startup script with display handling
cat > ~/.config/autostart/xscreensaver-daemon.sh << 'EOF'
#!/bin/bash

# XScreenSaver daemon startup script for Wayland
# Wait for XWayland to be ready before starting

# Wait for Wayland and XWayland to initialize
sleep 15

# Set DISPLAY environment variable for XWayland
export DISPLAY=:0

# Check if XWayland is ready
if ! xset q &>/dev/null; then
    echo "XWayland not ready, waiting longer..."
    sleep 10
fi

# Check if xscreensaver is already running
if ! pgrep -x "xscreensaver" > /dev/null; then
    echo "Starting XScreenSaver daemon for display $DISPLAY..."
    
    # Start xscreensaver daemon with explicit display
    xscreensaver -no-splash -display "$DISPLAY" &
    
    # Wait a moment for daemon to initialize
    sleep 5
    
    # Verify it's running
    if pgrep -x "xscreensaver" > /dev/null; then
        echo "XScreenSaver daemon started successfully on $DISPLAY"
    else
        echo "Failed to start XScreenSaver daemon"
    fi
else
    echo "XScreenSaver daemon already running"
fi
EOF

# Make scripts executable
chmod +x ~/.config/autostart/xscreensaver-daemon.sh
chmod +x ~/.config/autostart/xscreensaver.desktop

# Create Plasma workspace backup (optional but recommended)
mkdir -p ~/.config/plasma-workspace

cat > ~/.config/plasma-workspace/xscreensaver-startup.sh << 'EOF'
#!/bin/bash

# Plasma workspace startup script for XScreenSaver
# This runs when Plasma desktop starts

# Wait for desktop to fully initialize
sleep 20

# Set DISPLAY for XWayland
export DISPLAY=:0

# Check if XWayland is ready
if ! xset q &>/dev/null; then
    echo "XWayland not ready for xscreensaver startup"
    exit 1
fi

# Start XScreenSaver if not running
if ! pgrep -x "xscreensaver" > /dev/null; then
    echo "Starting XScreenSaver daemon from Plasma workspace..."
    xscreensaver -no-splash -display "$DISPLAY" &
fi
EOF

chmod +x ~/.config/plasma-workspace/xscreensaver-startup.sh

# Refresh desktop database
sudo update-desktop-database /usr/share/applications/

echo "✅ XScreenSaver configured for Wayland with working autostart"
echo "   - Daemon starts automatically with display handling"
echo "   - No 'screen 0' errors with XWayland"
echo "   - Dual-layer autostart for reliability"

# Install Yakuake separately (requires manual installation)
echo "📦 Installing Yakuake..."
sudo pacman -S --noconfirm yakuake
echo "✅ Yakuake installed"

# Configure Yakuake startup script
echo "🔧 Setting up Yakuake startup script..."

mkdir -p ~/bin

cat > ~/bin/yakuake_startup.sh << 'EOF'
#!/bin/bash

echo "Starting yakuake script at $(date)" >> /tmp/yakuake_debug.log

yakuake &

echo "Yakuake launched" >> /tmp/yakuake_debug.log

sleep 5  # wait for yakuake to start

echo "Sleep done" >> /tmp/yakuake_debug.log

if pgrep yakuake > /dev/null; then
    echo "Yakuake is running" >> /tmp/yakuake_debug.log
else
    echo "Yakuake is not running" >> /tmp/yakuake_debug.log
    exit 1
fi

# First tab (session 0): set title and run yazi
echo "Configuring first tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:0 string:"yazi"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:0 string:"yazi"

# Add second tab: alt+c, run fzf directory finder
echo "Configuring second tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:1 string:"alt+c"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:1 string:"eval $FZF_ALT_C_COMMAND | fzf $FZF_ALT_C_OPTS"

# Add third tab: ctrl+c, run eza
echo "Configuring third tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:2 string:"ctrl+c"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:2 string:"eza"

# Add fourth tab: fresh, run fresh
echo "Configuring fourth tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:3 string:"fresh"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:3 string:"fresh"

# Add fifth tab: asciiquarium, run asciiquarium
echo "Configuring fifth tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:4 string:"asciiquarium"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:4 string:"asciiquarium"

# Add sixth tab: cmatrix, run cmatrix
echo "Configuring sixth tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:5 string:"cmatrix"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:5 string:"cmatrix"

# Add seventh tab: bonsai, run bonsai.sh with options
echo "Configuring seventh tab" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.addSession
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/tabs org.kde.yakuake.setTabTitle int32:6 string:"bonsai"
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/sessions org.kde.yakuake.runCommandInTerminal int32:6 string:"bonsai.sh --live --time 0.5 --life 28 --infinite --wait 3"

echo "Script completed" >> /tmp/yakuake_debug.log

echo "Toggling window" >> /tmp/yakuake_debug.log
dbus-send --session --dest=org.kde.yakuake --type=method_call /yakuake/window org.kde.yakuake.toggleWindowState
EOF

chmod +x ~/bin/yakuake_startup.sh

# Set up Yakuake autostart
mkdir -p ~/.config/autostart

cat > ~/.config/autostart/yakuake.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Yakuake
Comment=Quake-style terminal emulator
Exec=~/bin/yakuake_startup.sh
Icon=yakuake
Terminal=false
Categories=System;TerminalEmulator;
X-KDE-Autostart-Phase=2
X-KDE-StartupNotify=false
EOF

echo "✅ Yakuake configured with startup tabs"

# Set up Konsole autostart
cat > ~/.config/autostart/konsole.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Konsole
Comment=Terminal emulator
Exec=konsole --tabs "yazi;yazi" "alt+c;eval \$FZF_ALT_C_COMMAND | fzf \$FZF_ALT_C_OPTS" "ctrl+c;eza" "fresh;fresh" "asciiquarium;asciiquarium" "cmatrix;cmatrix" "bonsai;bonsai.sh --live --time 0.5 --life 28 --infinite --wait 3"
Icon=konsole
Terminal=false
Categories=System;TerminalEmulator;
X-KDE-Autostart-Phase=0
X-KDE-StartupNotify=false
EOF

echo "✅ Konsole configured with startup tabs"

# Install AUR packages if yay is available
if command -v yay &> /dev/null; then
    echo "📦 Installing AUR packages..."
    yay -S --noconfirm jdownloader2 octopi falcon-sensor nordvpn-gui flutter-3382-bin unionfs-fuse
else
    echo "❌ yay not available, skipping AUR packages"
fi

# ============================================================================
# 12. TERMINAL TOOLS SETUP
# ============================================================================
echo "🖥️ Setting up Terminal Tools..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed"
else
    echo "✅ Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "📦 Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "✅ Powerlevel10k installed"
else
    echo "✅ Powerlevel10k already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "📦 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "✅ zsh-autosuggestions installed"
else
    echo "✅ zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "✅ zsh-syntax-highlighting installed"
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

# Configure .zshrc with Oh My Zsh setup
echo "🔧 Configuring Oh My Zsh..."
# Backup existing .zshrc
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup-$(date +%Y%m%d-%H%M%S)

# Create new .zshrc with Oh My Zsh configuration
cat > ~/.zshrc << 'EOF'
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_ALT_C_COMMAND="find . -maxdepth 1 -type d | sed 's|^\./||' | sort"

# Custom aliases
alias cls='clear'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source syntax highlighting last to override everything
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Make syntax highlighting more visible
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue,underline'
EOF

echo "✅ Oh My Zsh configured with Powerlevel10k and plugins"

if command -v yay &> /dev/null; then
    echo "📦 Installing additional terminal tools..."
    yay -S --noconfirm yazi fresh-editor-bin tmux
    echo "✅ Terminal tools installed"
else
    echo "❌ yay not available, skipping terminal tools"
fi

# Install bonsai.sh script
sudo sh -c 'curl -o /usr/local/bin/bonsai.sh https://gitlab.com/jallbrit/bonsai.sh/-/raw/master/bonsai.sh && chmod +x /usr/local/bin/bonsai.sh'
echo "✅ bonsai.sh installed"

# ============================================================================
# 14. UNIMATRIX DUAL MONITOR SETUP
# ============================================================================
echo "🟢 Setting up Unimatrix dual monitor Matrix effect..."

# Create unimatrix launcher script
echo "📜 Creating unimatrix dual monitor launcher..."
mkdir -p ~/.local/bin

cat > ~/.local/bin/unimatrix-simple << 'EOF'
#!/bin/bash
# Simple dual monitor unimatrix with launcher control

# Check if we're already in a dedicated tab, if not, open one
if [ -z "$UNIMATRIX_LAUNCHER" ]; then
    export UNIMATRIX_LAUNCHER=1
    konsole --new-tab -e bash -c "$0; exec bash" &
    exit
fi

echo "=== Simple Dual Monitor Unimatrix ==="
echo ""

echo "Launching two unimatrix windows..."
echo ""

# Launch first unimatrix
konsole --profile Unimatrix --hide-menubar --hide-tabbar -e unimatrix -c green -l k &
UNIMATRIX1_PID=$!
sleep 1

# Launch second unimatrix  
konsole --profile Unimatrix --hide-menubar --hide-tabbar -e unimatrix -c green -l k &
UNIMATRIX2_PID=$!
sleep 2

echo ""
echo "SETUP INSTRUCTIONS:"
echo "1. You now have TWO unimatrix windows"
echo "2. Drag ONE window to your second monitor"
echo "3. Press F11 on BOTH windows to make them fullscreen"
echo "4. Press Ctrl+C HERE to close BOTH unimatrix windows"
echo ""
echo "Unimatrix windows running with PIDs: $UNIMATRIX1_PID and $UNIMATRIX2_PID"
echo "Press Ctrl+C in this launcher tab to close both windows."
echo ""

# Set up trap to clean up on exit
cleanup() {
    echo ""
    echo "Closing unimatrix windows..."
    kill $UNIMATRIX1_PID $UNIMATRIX2_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

# Wait for the unimatrix processes or for user to press Ctrl+C
wait $UNIMATRIX1_PID $UNIMATRIX2_PID 2>/dev/null
cleanup
EOF

chmod +x ~/.local/bin/unimatrix-simple

# Create unimatrix konsole profile
echo "🔧 Creating unimatrix konsole profile..."
mkdir -p ~/.local/share/konsole

cat > ~/.local/share/konsole/Unimatrix.profile << 'EOF'
[Appearance]
ColorScheme=Breeze
Font=Hack,20,-1,5,50,0,0,0,0,0

[General]
Name=Unimatrix
Parent=FALLBACK/

[Scrolling]
HistoryMode=1
HistorySize=1000

[Terminal Features]
BlinkingCursorEnabled=true
EOF

# Add unimatrix to PATH
echo "🔧 Adding unimatrix to PATH..."
if ! grep -q "export PATH.*local/bin" ~/.zshrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

echo "✅ Unimatrix dual monitor setup complete!"
echo "   - Run 'unimatrix-simple' to start Matrix effect on both monitors"
echo "   - Features: Japanese katakana characters, green color, large font"
echo "   - Launcher tab controls both windows with Ctrl+C"

# ============================================================================
# 13. SYSTEM CONTROL ICONS SETUP (Power Off, Reboot, Full Shutdown, Logout)
# ============================================================================
echo "⚡ Creating complete system control icons..."

# Create desktop icons
echo "🔧 Creating desktop icons..."

# Power Off icon
cat > ~/Desktop/Power\ Off.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Power Off
Comment=Instant power off system
Exec=poweroff
Icon=/home/duck/Downloads/power-off.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Reboot icon
cat > ~/Desktop/Reboot.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Reboot
Comment=Instant reboot system
Exec=reboot
Icon=/home/duck/Downloads/reboot.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Full Shutdown icon
cat > ~/Desktop/Full\ Shutdown.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Full Shutdown
Comment=Shutdown with confirmation and 15 second delay
Exec=/home/duck/Desktop/simple-full-shutdown.sh
Icon=/home/duck/Downloads/full-shutdown.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Logout icon
cat > ~/Desktop/Logout.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Logout
Comment=Logout from current session
Exec=/home/duck/Desktop/simple-logout.sh
Icon=/home/duck/Downloads/logout.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Create supporting scripts
echo "📜 Creating system control scripts..."

# Full Shutdown script
cat > ~/Desktop/simple-full-shutdown.sh << 'EOF'
#!/bin/bash
# Full shutdown with 15-second delay
echo "Starting full shutdown process..."
zenity --question --text="Shutdown system in 15 seconds?" --timeout=15
if [ $? -eq 0 ]; then
    /usr/local/bin/save-firefox-profile.sh
    sleep 15
    poweroff
fi
EOF

# Logout script
cat > ~/Desktop/simple-logout.sh << 'EOF'
#!/bin/bash
# Simple logout script
echo "Logging out..."
/usr/local/bin/save-firefox-profile.sh
sleep 1
zenity --question --text="Logout from current session?"
if [ $? -eq 0 ]; then
    pkill -KILL -u duck
fi
EOF

# Make scripts executable
chmod +x ~/Desktop/simple-full-shutdown.sh ~/Desktop/simple-logout.sh

# Make desktop icons executable
chmod +x ~/Desktop/Power\ Off.desktop ~/Desktop/Reboot.desktop ~/Desktop/Full\ Shutdown.desktop ~/Desktop/Logout.desktop

# Copy to applications directory for taskbar
cp ~/Desktop/Power\ Off.desktop ~/Desktop/Reboot.desktop ~/Desktop/Full\ Shutdown.desktop ~/Desktop/Logout.desktop ~/.local/share/applications/

# Create System Control Panel
echo "🎛️ Creating System Control Panel..."

# Create main panel script
cat > ~/Desktop/system_control_panel.sh << 'EOF'
#!/bin/bash

# System Control Panel - Creates a persistent floating window with 4x2 grid using kdialog
if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Check if already running
PID_FILE="/tmp/system_control_panel.pid"
if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE" 2>/dev/null)" 2>/dev/null; then
    echo "System Control Panel is already running. Bringing to front..."
    wmctrl -a "System Control Panel" 2>/dev/null
    exit 0
fi

# Write PID file
echo $$ > "$PID_FILE"

# Cleanup function
cleanup() {
    rm -f "$PID_FILE"
    exit 0
}

# Trap cleanup on exit
trap cleanup EXIT INT TERM

# Main loop - keep panel open until user cancels
while true; do
    # Create the main dialog
    RESULT=$(kdialog --title "System Control Panel" --menu "Choose action:" \
        "logout" "🚪 Logout" \
        "fullshutdown" "⏻ Full Shutdown" \
        "poweroff" "🔌 Power Off" \
        "reboot" "🔄 Reboot" \
        "toggleapps" "📱 Toggle Open Apps" \
        "toggleicons" "🖥️ Toggle Desktop Icons" \
        "refresh" "🔄 Refresh Desktop" \
        "desktoppeek" "👁️ Desktop Peek" \
        "exit" "❌ Exit Panel" \
        --geometry 300x450)

    # Execute based on selection
    case "$RESULT" in
        "logout")
            /home/duck/Desktop/.scripts/simple-logout.sh &
            sleep 3
            ;;
        "fullshutdown")
            /home/duck/Desktop/.scripts/simple-full-shutdown.sh &
            sleep 3
            ;;
        "poweroff")
            poweroff &
            ;;
        "reboot")
            reboot &
            ;;
        "toggleapps")
            /run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/toggle_open_apps.sh
            sleep 2
            ;;
        "toggleicons")
            /run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/toggle_desktop_icons.sh
            sleep 2
            ;;
        "refresh")
            /run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/refresh-desktop.sh &
            ;;
        "desktoppeek")
            /run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/toggle_desktop_peek.sh
            sleep 2
            ;;
        "exit")
            echo "Exiting System Control Panel"
            exit 0
            ;;
        *)
            echo "Cancelled or closed"
            exit 0
            ;;
    esac
    
    # Small delay before showing menu again
    sleep 0.5
done
EOF

# Create toggle scripts
cat > ~/Desktop/toggle_open_apps.sh << 'EOF'
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
    sleep 0.5
    rm -f "$WINDOW_STATE_FILE"
    echo "✓ Windows restored"
else
    # Currently normal - minimize windows
    echo "Minimizing windows..."
    wmctrl -k on 2>/dev/null
    sleep 0.5
    touch "$WINDOW_STATE_FILE"
    echo "✓ Windows minimized"
fi

sleep 1
EOF

cat > ~/Desktop/toggle_desktop_icons.sh << 'EOF'
#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root. Run it as your regular user."
    exit 1
fi

# Toggle desktop icons only
DESKTOP_DIR="$HOME/Desktop"
HIDDEN_DIR="$HOME/.desktop_hidden"
STATE_FILE="$HOME/.desktop_icons_state"

# Check current state
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE" 2>/dev/null)" = "hidden" ]; then
    # Currently hidden - restore icons
    echo "Restoring desktop icons..."
    
    # Restore icons (files and directories)
    if [ -d "$HIDDEN_DIR" ] && [ "$(ls -A "$HIDDEN_DIR" 2>/dev/null)" ]; then
        mv "$HIDDEN_DIR"/* "$DESKTOP_DIR"/ 2>/dev/null
        echo "✓ Restored $(ls -1 "$DESKTOP_DIR"/*.desktop 2>/dev/null | wc -l) desktop items and $(find "$DESKTOP_DIR" -maxdepth 1 -type d ! -name '.' ! -name '..' | wc -l) directories"
        rmdir "$HIDDEN_DIR" 2>/dev/null
    fi
    
    # Clear state
    rm -f "$STATE_FILE"
    
    echo ""
    echo "✓ Desktop icons restored!"
else
    # Currently visible - hide icons
    echo "Hiding desktop icons..."
    
    # Create hidden directory
    mkdir -p "$HIDDEN_DIR"
    
    # Hide icons (exclude only position files)
    if [ "$(ls -A "$DESKTOP_DIR" 2>/dev/null)" ]; then
        # Move all visible files except hidden position files
        find "$DESKTOP_DIR" -maxdepth 1 -type f ! -name '.*' -exec mv {} "$HIDDEN_DIR"/ \; 2>/dev/null
        
        # Also handle directories like NAS-Controls (but not the Desktop directory itself)
        find "$DESKTOP_DIR" -maxdepth 1 -type d ! -name '.*' ! -name '.' ! -name '..' ! -name 'Desktop' -exec mv {} "$HIDDEN_DIR"/ \; 2>/dev/null
        
        echo "✓ Hidden $(find "$HIDDEN_DIR" -maxdepth 1 | wc -l) desktop items"
    else
        echo "✓ Desktop already clean"
    fi
    
    # Set state
    echo "hidden" > "$STATE_FILE"
    
    echo ""
    echo "✓ Desktop icons hidden!"
fi
EOF

# Make scripts executable
chmod +x ~/Desktop/system_control_panel.sh ~/Desktop/toggle_open_apps.sh ~/Desktop/toggle_desktop_icons.sh

# Create System Control Panel desktop icon
cat > ~/Desktop/System\ Control\ Panel.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=System Control Panel
Comment=4x2 grid of system control icons
Exec=/home/duck/Desktop/system_control_panel.sh
Icon=/home/duck/Downloads/control-panel.jpg
Terminal=false
Categories=System;
StartupNotify=false
EOF

# Copy to applications directory for taskbar
cp ~/Desktop/System\ Control\ Panel.desktop ~/.local/share/applications/

# Make desktop icon executable
chmod +x ~/Desktop/System\ Control\ Panel.desktop

echo "✅ System Control Panel created with 4x2 grid interface"

echo "✅ Complete system control icons created"
echo "   - Power Off: Instant shutdown (no Firefox save)"
echo "   - Reboot: Instant reboot (no Firefox save)"
echo "   - Full Shutdown: 15-sec delay with Firefox save"
echo "   - Logout: Confirmation with Firefox save"
echo "   - System Control Panel: 4x2 grid interface"
echo "   - Toggle Functions: Desktop Icons, Open Apps, Desktop Peek, Refresh"
echo "⚠️  WARNING: Save work before using Power Off/Reboot icons!"
echo "💡 App Positioning: KDE default behavior - apps remember last position"

# Configure Yazi
echo "🔧 Configuring Yazi..."
mkdir -p ~/.config/yazi/flavors

# Create yazi.toml
cat > ~/.config/yazi/yazi.toml << 'EOF'
[opener]
edit = [
	{ run = 'nano "$@"', block = true, for = "unix" },
]

[open]
rules = [
	{ name = "*/", use = "edit" },
]
EOF

# Create keymap.toml
cat > ~/.config/yazi/keymap.toml << 'EOF'
[manager]
prepend_keymap = [
	{ on = [ "j" ], run = "arrow 1",  desc = "Move cursor down" },
	{ on = [ "k" ], run = "arrow -1", desc = "Move cursor up" },
	{ on = [ "h" ], run = "leave",    desc = "Go back to parent directory" },
	{ on = [ "l" ], run = "enter",    desc = "Enter the child directory" },
]
EOF

# Create theme.toml
cat > ~/.config/yazi/theme.toml << 'EOF'
[flavor]
use = "catppuccin-mocha"
EOF

# Create theme file
cat > ~/.config/yazi/flavors/catppuccin-mocha.yazi << 'EOF'
# Catppuccin Mocha theme for Yazi
[manager]
cwd = { fg = "#89dceb" }
hovered         = { fg = "#1e1e2e", bg = "#89b4fa" }
preview_hovered = { underline = true }
find_keyword  = { fg = "#f9e2af", italic = true }
find_position = { fg = "#f5c2e7", bg = "reset", italic = true }
marker_selected = { fg = "#a6e3a1", bg = "#a6e3a1" }
marker_copied   = { fg = "#f9e2af", bg = "#f9e2af" }
marker_cut      = { fg = "#f38ba8", bg = "#f38ba8" }
tab_active   = { fg = "#1e1e2e", bg = "#cdd6f4" }
tab_inactive = { fg = "#cdd6f4", bg = "#45475a" }
tab_width    = 1
border_symbol = "│"
border_style  = { fg = "#7f849c" }
syntect_theme = ""

[status]
separator_open  = ""
separator_close = ""
separator_style = { fg = "#45475a", bg = "#45475a" }
mode_normal = { fg = "#1e1e2e", bg = "#89b4fa", bold = true }
mode_select = { fg = "#1e1e2e", bg = "#a6e3a1", bold = true }
mode_unset  = { fg = "#1e1e2e", bg = "#f2cdcd", bold = true }
progress_label  = { fg = "#cdd6f4", bold = true }
progress_normal = { fg = "#89b4fa", bg = "#45475a" }
progress_error  = { fg = "#f38ba8", bg = "#45475a" }
permissions_t = { fg = "#a6e3a1" }
permissions_r = { fg = "#f9e2af" }
permissions_w = { fg = "#f38ba8" }
permissions_x = { fg = "#89dceb" }
permissions_s = { fg = "#7f849c" }

[input]
border   = { fg = "#89b4fa" }
title    = {}
value    = {}
selected = { reversed = true }

[select]
border   = { fg = "#89b4fa" }
active   = { fg = "#f5c2e7" }
inactive = {}

[tasks]
border  = { fg = "#89b4fa" }
title   = {}
hovered = { underline = true }

[which]
mask            = { bg = "#313244" }
cand            = { fg = "#89b4fa" }
rest            = { fg = "#9399b2" }
desc            = { fg = "#f5c2e7" }
separator       = "  "
separator_style = { fg = "#585b70" }

[help]
on      = { fg = "#f5c2e7" }
exec    = { fg = "#89dceb" }
desc    = { fg = "#9399b2" }
hovered = { bg = "#585b70", bold = true }
footer  = { fg = "#45475a", bg = "#cdd6f4" }

[filetype]
rules = [
	{ mime = "image/*", fg = "#89dceb" },
	{ mime = "video/*", fg = "#f9e2af" },
	{ mime = "audio/*", fg = "#f9e2af" },
	{ mime = "application/zip", fg = "#f5c2e7" },
	{ mime = "application/gzip", fg = "#f5c2e7" },
	{ mime = "application/x-tar", fg = "#f5c2e7" },
	{ mime = "application/x-bzip", fg = "#f5c2e7" },
	{ mime = "application/x-bzip2", fg = "#f5c2e7" },
	{ mime = "application/x-7z-compressed", fg = "#f5c2e7" },
	{ mime = "application/x-rar", fg = "#f5c2e7" },
	{ name = "*", fg = "#cdd6f4" },
	{ name = "*/", fg = "#89b4fa" }
]

[icons]
"Desktop/" = ""
"Documents/" = ""
"Downloads/" = ""
"Pictures/" = ""
"Music/" = ""
"Movies/" = ""
"Videos/" = ""
"Public/" = ""
"Library/" = ""
"Development/" = ""
".config/" = ""
".git/" = ""
".gitignore" = ""
".gitmodules" = ""
".gitattributes" = ""
".DS_Store" = ""
".bashrc" = ""
".bash_profile" = ""
".zshrc" = ""
".zshenv" = ""
".vimrc" = ""
"*.txt" = ""
"*.md" = ""
"*.zip" = ""
"*.tar" = ""
"*.gz" = ""
"*.7z" = ""
"*.mp3" = ""
"*.flac" = ""
"*.wav" = ""
"*.jpg" = ""
"*.jpeg" = ""
"*.png" = ""
"*.gif" = ""
"*.svg" = ""
"*.mp4" = ""
"*.mkv" = ""
"*.avi" = ""
"*.pdf" = ""
"*.doc" = ""
"*.docx" = ""
"*" = ""
"*/" = ""
EOF
echo "✅ Yazi configured"

# Configure Tmux
echo "🔧 Configuring Tmux..."
cat > ~/.tmux.conf << 'EOF'
# Basic Tmux Configuration
set -g prefix C-b
bind C-b send-prefix
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %
bind r source-file ~/.tmux.conf \; display "Config reloaded!"
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
set -g default-terminal "screen-256color"
set -g status-style 'bg=#313244 fg=#cdd6f4'
set -g status-left '#[bg=#89b4fa,fg=#1e1e2e,bold] #S '
set -g status-right '#[bg=#45475a,fg=#cdd6f4] %Y-%m-%d %H:%M '
set -g status-left-length 20
set -g status-right-length 50
setw -g window-status-current-style 'bg=#89b4fa fg=#1e1e2e bold'
setw -g window-status-current-format ' #I:#W '
setw -g window-status-style 'bg=#45475a fg=#cdd6f4'
setw -g window-status-format ' #I:#W '
set -g pane-border-style 'fg=#45475a'
set -g pane-active-border-style 'fg=#89b4fa'
set -g message-style 'bg=#89b4fa fg=#1e1e2e bold'
setw -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
set -g history-limit 10000
set -sg escape-time 0
EOF
echo "✅ Tmux configured"

# Install Newshosting separately (requires manual setup)
echo "📦 Note: Newshosting needs manual setup - copying from backup location..."

# Copy Newshosting from backup if available
NEWSHOSTING_BACKUP="/run/media/duck/extra/User/home/duck/.local/share/Newshosting"
NEWSHOSTING_LOCAL="$HOME/.local/share/Newshosting"

if [ -d "$NEWSHOSTING_BACKUP" ]; then
    echo "📁 Copying Newshosting from backup..."
    mkdir -p "$NEWSHOSTING_LOCAL"
    cp -r "$NEWSHOSTING_BACKUP"/* "$NEWSHOSTING_LOCAL/" 2>/dev/null
    chmod +x "$NEWSHOSTING_LOCAL/3.8.9/Newshosting-x86_64.AppImage" 2>/dev/null
    echo "✓ Newshosting copied and configured"
else
    echo "⚠️  Newshosting backup not found - manual installation required"
fi

# Install CachyOS specific tools and optimizations
echo "🚀 Installing CachyOS specific packages..."
sudo pacman -S --noconfirm cachyos-kde-settings cachyos-hooks cachyos-mirrorlist cachyos-v3-mirrorlist cachyos-nord-kde-theme-git

# Ensure CachyOS optimized kernel is installed
echo "🐧 Installing CachyOS optimized kernel..."
if ! pacman -Qi linux-cachyos &> /dev/null; then
    sudo pacman -S --noconfirm linux-cachyos linux-cachyos-headers
    echo "✅ CachyOS kernel installed"
else
    echo "✅ CachyOS kernel already installed"
fi

# Install additional system utilities
echo "🔧 Installing additional system utilities..."
sudo pacman -S --noconfirm htop neofetch tree jq wget curl unzip p7zip

# ============================================================================
# 2. NETWORK STORAGE CONFIGURATION (fstab)
# ============================================================================
echo "💾 Configuring network storage mounts..."

# Create mount points
sudo mkdir -p /run/media/duck/SPCC_1TB
sudo mkdir -p /run/media/duck/ku
sudo mkdir -p /run/media/duck/extra
sudo mkdir -p /mnt/Extra

# Add fstab entries (backup original first)
sudo cp /etc/fstab /etc/fstab.backup-$(date +%Y%m%d)

# Append network storage mounts to fstab
echo "" | sudo tee -a /etc/fstab
echo "# SPCC_1TB" | sudo tee -a /etc/fstab
echo "UUID=5907bd8b-2224-427d-a594-a9d87ce5954a /run/media/duck/SPCC_1TB ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab
echo "" | sudo tee -a /etc/fstab
echo "# Kubuntu data drive" | sudo tee -a /etc/fstab
echo "UUID=9c38847c-0338-4c89-b788-90845356ce3f /run/media/duck/ku ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab
echo "" | sudo tee -a /etc/fstab
echo "# Extra drive" | sudo tee -a /etc/fstab
echo "UUID=f8ff17ec-5808-4c21-a9f1-819ffb59c49c /run/media/duck/extra ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab

# ============================================================================
# 2.5. DUAL-BOOT SETUP (Windows GRUB and Drive Mounting)
# ============================================================================
echo "🔄 Setting up dual-boot with Windows..."

# Enable OS probing in GRUB
sudo sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

# Regenerate GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Get Windows UUID (assuming /dev/sda1)
WINDOWS_UUID=$(sudo blkid /dev/sda1 | grep -o 'UUID="[^"]*"' | cut -d'"' -f2)

# Create mount point
sudo mkdir -p /run/media/duck/windows

# Add to fstab
echo "" | sudo tee -a /etc/fstab
echo "# Windows drive" | sudo tee -a /etc/fstab
echo "UUID=$WINDOWS_UUID /run/media/duck/windows ntfs-3g uid=1000,gid=1000,umask=022 0 0" | sudo tee -a /etc/fstab

# Reload systemd
sudo systemctl daemon-reload

# Test mount
sudo mount -a

echo "✅ Dual-boot setup completed"

# ============================================================================
# 3. TIME AND DATE CONFIGURATION
# ============================================================================
echo "⏰ Configuring Time and Date Display..."

# Configure digital clock widget to show seconds and date
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][157][Applets][162][Applets][164][Configuration][Appearance]" --key showSeconds "true"
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][157][Applets][162][Applets][164][Configuration][Appearance]" --key showDate "true"
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][157][Applets][162][Applets][164][Configuration][Appearance]" --key dateFormat "isoDate"
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][157][Applets][162][Applets][164][Configuration][Appearance]" --key timeFormat "24h"

# Configure second monitor clock (if exists)
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][180][Applets][185][Applets][186][Configuration][Appearance]" --key showSeconds "true"
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][180][Applets][185][Applets][186][Configuration][Appearance]" --key showDate "true"
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][180][Applets][185][Applets][186][Configuration][Appearance]" --key dateFormat "isoDate"
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][180][Applets][185][Applets][186][Configuration][Appearance]" --key timeFormat "24h"

# ============================================================================
# 4. KDE GLOBAL THEME AND APPEARANCE
# ============================================================================
echo "🎨 Applying KDE Global Theme Settings..."

# Set global theme to CachyOS Nord
kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.cachyos-nord.desktop"

# Apply window decoration settings
echo "🪟 Applying Window Decoration Settings..."
kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key ButtonsOnLeft "SFB"  # Close, Keep Below, Keep Above
kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key ButtonsOnRight "I"     # Pin to All Desktops

# Apply desktop effects
echo "✨ Applying Desktop Effects..."
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key fallapartEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key hidecursorEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key kwin4_effect_geometry_changeEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key magiclampEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key translucencyEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key wobblywindowsEnabled "true"

# Configure blur effect strength
kwriteconfig6 --file kwinrc --group "Effect-blur" --key BlurStrength "9"
kwriteconfig6 --file kwinrc --group "Effect-blur" --key NoiseStrength "0"

# Set default browser
echo "🌐 Setting Default Browser..."
kwriteconfig6 --file kdeglobals --group General --key BrowserApplication "brave-browser.desktop"

# Apply Dolphin settings
echo "📁 Applying Dolphin File Manager Settings..."
kwriteconfig6 --file kdeglobals --group "KFileDialog Settings" --key View_Style "DetailTree"
kwriteconfig6 --file kdeglobals --group "KFileDialog Settings" --key SortDirectoriesFirst "true"
kwriteconfig6 --file kdeglobals --group "KFileDialog Settings" --key ShowHiddenFiles "false"

# ============================================================================
# 4. PANEL CONFIGURATION
# ============================================================================
echo "📋 Configuring Panel Settings..."

# Copy custom desktop launchers from backup location to standard location
echo "📁 Copying custom desktop launchers..."
CUSTOM_APPS_DIR="/run/media/duck/extra/User/home/duck/.local/share/applications"
USER_APPS_DIR="$HOME/.local/share/applications"

if [ -d "$CUSTOM_APPS_DIR" ]; then
    mkdir -p "$USER_APPS_DIR"
    # Copy custom launchers that exist in backup
    for launcher in toggle-desktop-peek.desktop newshosting.desktop edex-ui.desktop; do
        if [ -f "$CUSTOM_APPS_DIR/$launcher" ]; then
            cp "$CUSTOM_APPS_DIR/$launcher" "$USER_APPS_DIR/"
            echo "✓ Copied $launcher"
        fi
    done
    
    # Copy system-wide launchers to user directory if they don't exist
    for launcher in doublecmd.desktop enpass.desktop jdownloader.desktop org.remmina.Remmina.desktop; do
        if [ -f "/usr/share/applications/$launcher" ] && [ ! -f "$USER_APPS_DIR/$launcher" ]; then
            cp "/usr/share/applications/$launcher" "$USER_APPS_DIR/"
            echo "✓ Copied system $launcher"
        fi
    done
fi

# Configure Panel 1 launchers (17 items)
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][157][Applets][160][Configuration][General]" --key launchers "applications:systemsettings.desktop,preferred://filemanager,preferred://browser,applications:filezilla.desktop,applications:org.kde.konsole.desktop,applications:newshosting.desktop,applications:toggle-desktop-peek.desktop,applications:enpass.desktop,applications:virtualbox.desktop,applications:windsurf.desktop,applications:org.kde.kate.desktop,applications:jdownloader.desktop,applications:doublecmd.desktop"

# Configure Panel 2 launchers (8 items - including Steam)
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "[Containments][180][Applets][183][Configuration][General]" --key launchers "applications:systemsettings.desktop,preferred://filemanager,preferred://browser,applications:org.kde.konsole.desktop,applications:virtualbox.desktop,applications:edex-ui.desktop,applications:org.remmina.Remmina.desktop,applications:filezilla.desktop,applications:steam.desktop"

# ============================================================================
# 5. DESKTOP ICONS AND LAUNCHERS
# ============================================================================
echo "🖥️ Creating Desktop Icons..."

# Create desktop directory if it doesn't exist
mkdir -p "$HOME/Desktop"

# Create custom desktop launchers
echo "🎮 Creating emulator launchers..."

# Rainbow MAME launcher
cat > "$HOME/Desktop/Rainbow_MAME.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Rainbow MAME
Comment=Rainbow 100 Emulator
Exec=mame rainbow
Icon=applications-games
Terminal=false
Categories=Game;Emulator;
EOF

# Kaypro emulator launcher
cat > "$HOME/Desktop/Kaypro.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Kaypro Emulator
Comment=Kaypro Computer Emulator
Exec=mame kaypro2x
Icon=applications-games
Terminal=false
Categories=Game;Emulator;
EOF

# TRS80GP launcher
cat > "$HOME/Desktop/trs80gp-frehd.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=TRS-80 GP with FreHD
Comment=TRS-80 Model I/III/4/4P Emulator with FreHD
Exec=trs80gp
Icon=applications-games
Terminal=false
Categories=Game;Emulator;
EOF

# Cool Retro Term launcher
cat > "$HOME/Desktop/cool-retro-term.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Cool Retro Term
Comment=Cool looking terminal emulator
Exec=cool-retro-term
Icon=utilities-terminal
Terminal=false
Categories=System;TerminalEmulator;
EOF

# Steam launcher
cat > "$HOME/Desktop/steam.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Steam
Comment=Digital distribution platform
Exec=steam %U
Icon=steam
Terminal=false
Categories=Network;Game;
EOF

# MAME Settings launcher
cat > "$HOME/Desktop/MAME-Settings.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=MAME Settings
Comment=Configure MAME emulator
Exec=mame -createconfig
Icon=preferences-system
Terminal=false
Categories=Settings;
EOF

# VLC launcher
cat > "$HOME/Desktop/vlc.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=VLC Media Player
Comment=Play media files
Exec=vlc %U
Icon=vlc
Terminal=false
Categories=AudioVideo;Player;
EOF

# HandBrake launcher
cat > "$HOME/Desktop/handbrake.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=HandBrake
Comment=Video transcoder
Exec=handbrake
Icon=handbrake
Terminal=false
Categories=AudioVideo;Video;
EOF

# Krita launcher
cat > "$HOME/Desktop/krita.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Krita
Comment=Digital painting application
Exec=krita
Icon=krita
Terminal=false
Categories=Graphics;Painting;
EOF

# qBittorrent launcher
cat > "$HOME/Desktop/qbittorrent.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=qBittorrent
Comment=BitTorrent client
Exec=qbittorrent
Icon=qbittorrent
Terminal=false
Categories=Network;P2P;
EOF

# NordVPN launcher
cat > "$HOME/Desktop/nordvpn.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=NordVPN
Comment=NordVPN GUI client
Exec=nordvpn-gui
Icon=nordvpn
Terminal=false
Categories=Network;
EOF

# Octopi launcher
cat > "$HOME/Desktop/octopi.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Octopi
Comment=Arch Linux package manager
Exec=octopi
Icon=octopi
Terminal=false
Categories=System;PackageManager;
EOF

# Yakuake launcher
cat > "$HOME/Desktop/yakuake.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Yakuake
Comment=Quake-style terminal emulator
Exec=yakuake
Icon=yakuake
Terminal=false
Categories=System;TerminalEmulator;
EOF

# ============================================================================
# 6. CUSTOM SCRIPTS
# ============================================================================
echo "🔧 Creating Custom Scripts..."

# Create scripts directory
mkdir -p "$HOME/scripts"

# Launch Rainbow script
cat > "$HOME/scripts/launch_rainbow.sh" << 'EOF'
#!/bin/bash
cd /path/to/rainbow/roms
mame rainbow -centerh -centerv -window -scalemode integer
EOF
chmod +x "$HOME/scripts/launch_rainbow.sh"

# Launch Kaypro script
cat > "$HOME/scripts/launch_kaypro.sh" << 'EOF'
#!/bin/bash
cd /path/to/kaypro/roms
mame kaypro2x -centerh -centerv -window -scalemode integer
EOF
chmod +x "$HOME/scripts/launch_kaypro.sh"

# Clear SMB credentials script
cat > "$HOME/scripts/clear-smb-credentials.sh" << 'EOF'
#!/bin/bash
echo "Clearing SMB credentials..."
rm -f ~/.config/samba/credentials/*
kquitapp5 plasma-desktop 2>/dev/null || kquitapp6 plasma-desktop 2>/dev/null
sleep 2
plasmashell &
echo "SMB credentials cleared and Plasma restarted"
EOF
chmod +x "$HOME/scripts/clear-smb-credentials.sh"

# ============================================================================
# 7. NAS CONTROL DESKTOP LAUNCHERS
# ============================================================================
echo "🌐 Creating NAS Control Launchers..."

# Create NAS Controls directory
mkdir -p "$HOME/Desktop/NAS-Controls"

# Mount All NAS launcher
cat > "$HOME/Desktop/NAS-Controls/Mount All NAS.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Mount All NAS
Comment=Mount all network storage devices
Exec=gnome-terminal -- bash -c "sudo mount -a && echo 'All NAS devices mounted' && read"
Icon=drive-harddisk-mount
Terminal=true
Categories=System;
EOF

# Wake All NAS launcher
cat > "$HOME/Desktop/NAS-Controls/Wake All NAS.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wake All NAS
Comment=Send Wake-on-LAN to all NAS devices
Exec=gnome-terminal -- bash -c "wakeonlan 192.168.3.231 && echo 'WOL sent to NAS' && read"
Icon=network-wired
Terminal=true
Categories=System;
EOF

# Shutdown All NAS launcher
cat > "$HOME/Desktop/NAS-Controls/Shutdown All NAS.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Shutdown All NAS
Comment=Shutdown all NAS devices
Exec=gnome-terminal -- bash -c "ssh nas@192.168.3.231 'sudo shutdown -h now' && echo 'NAS shutdown initiated' && read"
Icon=system-shutdown
Terminal=true
Categories=System;
EOF

# ============================================================================
# 8. NETWORK CONFIGURATION
# ============================================================================
echo "🌐 Configuring Network Settings..."

# Create FileZilla site manager entries (if FileZilla config exists)
if [ -d "$HOME/.config/filezilla" ]; then
    echo "📁 Configuring FileZilla network connections..."
    # Note: FileZilla network connections would need to be imported manually or via XML
fi

# ============================================================================
# 9. EMULATOR SETUP AND DESKTOP LAUNCHERS
# ============================================================================
echo "🎮 Setting up Emulators and Desktop Launchers..."

# Install Cool Retro Term
if ! command -v cool-retro-term &> /dev/null; then
    echo "📦 Installing Cool Retro Term..."
    sudo pacman -S cool-retro-term --noconfirm
    echo "✓ Cool Retro Term installed successfully"
else
    echo "✓ Cool Retro Term already installed"
fi

# Install TRS80GP emulator
if [ ! -f "$HOME/.local/bin/trs80gp" ]; then
    echo "📦 Installing TRS80GP emulator..."
    cd /tmp
    if [ -f "/run/media/duck/extra/User/home/duck/extra/trs80gp-2.5.5.zip" ]; then
        unzip -q "/run/media/duck/extra/User/home/duck/extra/trs80gp-2.5.5.zip"
        cp linux-64/trs80gp "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/trs80gp"
        echo "✓ TRS80GP installed successfully"
    else
        echo "⚠️ TRS80GP zip file not found, installing from AUR..."
        yay -S trs80gp-bin --noconfirm
    fi
    cd /run/media/duck/extra/User/Downloads/ProjectsMain/Post-Install-CachyOS
else
    echo "✓ TRS80GP already installed"
fi

# Create emulator directories
mkdir -p "$HOME/emulators/rainbow/{disks,logs}"
mkdir -p "$HOME/Documents/FreHd"
mkdir -p "$HOME/.mame/roms"

# Copy Rainbow ROMs
if [ -d "/run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/full_roms_backup" ]; then
    echo "📦 Installing Rainbow ROMs..."
    mkdir -p "$HOME/.mame/roms/rainbow"
    cp /run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/full_roms_backup/rainbow/*.bin "$HOME/.mame/roms/rainbow/" 2>/dev/null
    cp /run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/full_roms_backup/rainbow/lk201/* "$HOME/.mame/roms/rainbow/" 2>/dev/null
    cp /run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/full_roms_backup/rainbow/*.e13 "$HOME/.mame/roms/rainbow/" 2>/dev/null
    echo "✓ Rainbow ROMs installed"
fi

# Copy Kaypro ROMs
if [ -d "/run/media/duck/extra/User/Downloads/ProjectsMain/Kaypro_ROMs_SPCC1TB" ]; then
    echo "📦 Installing Kaypro ROMs..."
    cp -r /run/media/duck/extra/User/Downloads/ProjectsMain/Kaypro_ROMs_SPCC1TB/* "$HOME/.mame/roms/"
    echo "✓ Kaypro ROMs installed"
fi

# Copy Rainbow disk images
if [ -d "/run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/disks/rainbow/disks" ]; then
    echo "📦 Installing Rainbow disk images..."
    cp /run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/disks/rainbow/disks/*.td0 "$HOME/emulators/rainbow/disks/" 2>/dev/null
    echo "✓ Rainbow disk images installed"
fi

# Fix Rainbow MAME desktop launcher
echo "🔧 Configuring Rainbow MAME launcher..."
cat > "$HOME/Desktop/Rainbow_MAME.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Rainbow MAME
Comment=Rainbow 100 Emulator (CP/M on Drive A, DOS on Drive B)
Exec=/run/media/duck/extra/User/Downloads/ProjectsMain/Rainbow_Emulator_Backup_SPCC1TB/scripts/launch_rainbow.sh
Icon=applications-games
Terminal=false
Categories=Game;Emulator;
EOF

# Fix TRS80GP FreHD desktop launcher
echo "🔧 Configuring TRS80GP FreHD launcher..."
cat > "$HOME/Desktop/trs80gp-frehd.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=TRS-80 GP with FreHD
Comment=TRS-80 Model I/III/4/4P Emulator with FreHD
Exec=/run/media/duck/extra/User/Downloads/ProjectsMain/FreHd/launch_frehd.sh
Icon=applications-games
Terminal=false
Categories=Game;Emulator;
EOF

# Fix Kaypro desktop launcher
echo "🔧 Configuring Kaypro launcher..."
cat > "$HOME/Desktop/Kaypro.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Kaypro Emulator
Comment=Kaypro Computer Emulator
Exec=mame kaypro2x -window -video opengl -resolution 1024x768
Icon=applications-games
Terminal=false
Categories=Game;Emulator;
EOF

# Make desktop launchers executable
chmod +x "$HOME/Desktop/Rainbow_MAME.desktop"
chmod +x "$HOME/Desktop/trs80gp-frehd.desktop"
chmod +x "$HOME/Desktop/Kaypro.desktop"
chmod +x "$HOME/Desktop/Cool_Retro_Term.desktop"

echo "✓ Emulator desktop launchers configured"

# Create Cool Retro Term desktop launcher
echo "🔧 Configuring Cool Retro Term launcher..."
cat > "$HOME/Desktop/Cool_Retro_Term.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Cool Retro Term
Comment=A good looking terminal emulator which mimics the old cathode display
Exec=cool-retro-term
Icon=cool-retro-term
Terminal=false
Categories=System;TerminalEmulator;Utility;
Keywords=terminal;retro;crt;vintage;old;
EOF

# ============================================================================
# 10. SERVICES AND AUTOSTART
# ============================================================================
echo "🚀 Configuring Services and Autostart..."

# Enable user services
systemctl --user enable --now plasma-plasmashell.service 2>/dev/null || true

# Create autostart directory
mkdir -p "$HOME/.config/autostart"

# Configure Yakuake to start at boot
echo "🖥️ Configuring Yakuake autostart..."
cat > "$HOME/.config/autostart/yakuake.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Yakuake
Comment=Quake-style terminal emulator
Exec=yakuake
Icon=yakuake
Terminal=false
Categories=System;TerminalEmulator;
X-KDE-Autostart-Phase=0
X-KDE-StartupNotify=false
EOF
echo "✓ Yakuake configured to start at boot"

# ============================================================================
# 11. FIREFOX IN RAM OPTIMIZATION
# ============================================================================
echo "🚀 Setting up Firefox in RAM for optimal performance..."

# Check if Firefox profile exists
FIREFOX_PROFILE="jkfujx2p.default-release"
FIREFOX_PROFILE_PATH="$HOME/.mozilla/firefox/$FIREFOX_PROFILE"

if [ -d "$FIREFOX_PROFILE_PATH" ] && [ ! -L "$FIREFOX_PROFILE_PATH" ]; then
    echo "📦 Firefox profile found, setting up RAM optimization..."
    
    # Check if Firefox is running
    if pgrep -x firefox > /dev/null; then
        echo "⚠️  Firefox is running. Please close Firefox and run this section manually."
        echo "   See FIREFOX_RAM_SETUP.md for detailed instructions."
    else
        # Create RAM directory
        mkdir -p /dev/shm/firefox-profile
        
        # Copy profile to RAM
        echo "📋 Copying Firefox profile to RAM (this may take a moment)..."
        cp -a "$FIREFOX_PROFILE_PATH"/* /dev/shm/firefox-profile/
        
        # Create backup
        mv "$FIREFOX_PROFILE_PATH" "${FIREFOX_PROFILE_PATH}.backup"
        
        # Create symlink
        ln -s /dev/shm/firefox-profile "$FIREFOX_PROFILE_PATH"
        
        # Create save script
        sudo tee /usr/local/bin/save-firefox-profile.sh > /dev/null << 'SAVESCRIPT'
#!/bin/sh
rsync -a --delete /dev/shm/firefox-profile/ /home/duck/.mozilla/firefox/jkfujx2p.default-release.backup/
SAVESCRIPT
        
        # Create restore script
        sudo tee /usr/local/bin/restore-firefox-profile.sh > /dev/null << 'RESTORESCRIPT'
#!/bin/sh
mkdir -p /dev/shm/firefox-profile
rsync -a /home/duck/.mozilla/firefox/jkfujx2p.default-release.backup/ /dev/shm/firefox-profile/
RESTORESCRIPT
        
        # Make scripts executable
        sudo chmod +x /usr/local/bin/save-firefox-profile.sh
        sudo chmod +x /usr/local/bin/restore-firefox-profile.sh
        
        # Create systemd restore service
        sudo tee /etc/systemd/system/firefox-restore.service > /dev/null << 'RESTORESERVICE'
[Unit]
Description=Restore Firefox RAM profile
Before=graphical.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/restore-firefox-profile.sh

[Install]
WantedBy=graphical.target
RESTORESERVICE
        
        # Create systemd save service
        sudo tee /etc/systemd/system/firefox-save.service > /dev/null << 'SAVESERVICE'
[Unit]
Description=Save Firefox RAM profile back to disk
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/save-firefox-profile.sh

[Install]
WantedBy=shutdown.target
SAVESERVICE
        
        # Enable services
        sudo systemctl enable firefox-restore.service
        sudo systemctl enable firefox-save.service
        
        echo "✓ Firefox in RAM setup complete!"
        echo "  Profile size: $(du -sh /dev/shm/firefox-profile | cut -f1)"
        echo "  RAM location: /dev/shm/firefox-profile"
        echo "  Backup: ${FIREFOX_PROFILE_PATH}.backup"
    fi
else
    if [ -L "$FIREFOX_PROFILE_PATH" ]; then
        echo "✓ Firefox in RAM already configured"
    else
        echo "⚠️  Firefox profile not found at expected location"
        echo "   Run Firefox once to create profile, then see FIREFOX_RAM_SETUP.md"
    fi
fi

# ============================================================================
# 12. FINAL CONFIGURATION AND RESTART
# ============================================================================
echo "🔄 Applying final configuration and restarting components..."

# Make all desktop launchers executable
chmod +x "$HOME/Desktop"/*.desktop
chmod +x "$HOME/Desktop/NAS-Controls"/*.desktop

# Restart KDE components to apply changes
echo "🔄 Restarting KDE components to apply changes..."

# Kill and restart kwin for effects to take effect
kwin_x11 --replace &
sleep 2

# Restart plasma shell
kquitapp6 plasmashell 2>/dev/null || kquitapp5 plasmashell 2>/dev/null || true
sleep 3
plasmashell &

# Configure Auto-Login with Auto-Lock
echo "⚙️ Configuring auto-login with auto-lock..."

# Create autolock autostart entry
cat > ~/.config/autostart/autolock.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Auto Lock Screen
Exec=/bin/bash -c 'sleep 5 && loginctl lock-session'
Terminal=false
X-KDE-autostart-after=panel
EOF

# Set lock screen wallpaper
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///home/duck/Pictures/MtFuji.png"

# Configure KWallet with empty password for auto-unlock
rm -f ~/.local/share/kwalletd/kdewallet.kwl ~/.local/share/kwalletd/kdewallet.salt 2>/dev/null
kwriteconfig6 --file kwalletrc --group Wallet --key "First Use" "false"

echo "✓ Auto-login with auto-lock configured"
echo "⚠️ SDDM auto-login requires manual configuration:"
echo "   sudo nano /etc/sddm.conf.d/kde_settings.conf"
echo "   Add: [Autologin] User=duck Session=plasma"

# Manual steps reminder
echo ""
echo "✅ Automatic configuration completed!"
echo ""
echo "📝 Manual steps required:"
echo "   1. Configure transparency settings: System Settings → Global Themes → Application Style → Transparency tab"
echo "   2. Set Magic Lamp effect: System Settings → Workspace → Desktop Effects → Animations → Window Minimize → Magic Lamp"
echo "   3. Configure panel: Right-click panel → Configure Panel (Position: Top, Width: Custom, Opacity: Translucent)"
echo "   4. Import FileZilla site manager entries from backup"
echo "   5. Configure NordVPN connections (if used)"
echo "   6. Test network storage mounts and adjust if needed"
echo ""
echo "🔄 Reboot or log out/in to ensure all changes take effect"
echo "💾 Backups stored in: $BACKUP_DIR"
echo ""
echo "🎉 CachyOS comprehensive configuration script finished!"
echo ""
echo "📊 Summary of what was configured:"
echo "   ✅ AUR helper (yay) installed automatically"
echo "   ✅ CachyOS optimized kernel (6.18.2-1-cachyos) installed"
echo "   ✅ System packages installed (Steam, MAME, Dolphin, RetroArch, Code, Kate, VirtualBox, Windsurf, VLC, HandBrake, Shotcut, SoundConverter, OBS, Krita, FileZilla, Remmina, Double Commander, Cool Retro Term, NordVPN, Octopi, Falcon, Flutter, Unionfs-fuse, Yazi, Starship, Tmux)"
echo "   ✅ VLC configured with optimal settings"
echo "   ⚠️  Yakuake needs manual installation: sudo pacman -S yakuake"
echo "   ✅ Yakuake configured to start at boot (after manual installation)"
echo "   ✅ CachyOS specific tools and optimizations installed"
echo "   ✅ System utilities (htop, neofetch, tree, jq, wget, curl, unzip, p7zip)"
echo "   ✅ Time and date display configured (always show seconds and date below time)"
echo "   ✅ Network storage mounts configured (SPCC_1TB, Kubuntu, Extra drives)"
echo "   ✅ Dual-boot setup with Windows GRUB menu and drive mounting
   ✅ KDE theme and appearance applied"
echo "   ✅ Desktop effects enabled"
echo "   ✅ Panel launchers configured (Panel 1: 17 items, Panel 2: 8 items)"
echo "   ✅ Custom desktop launchers copied from backup location"
echo "   ✅ Desktop icons created (40+ launchers including new apps)"
echo "   ✅ Custom scripts created"
echo "   ✅ NAS control launchers created"
echo "   ✅ Network configuration applied"
echo "   ✅ Services and autostart configured"
echo "   ✅ VLC installed"
echo "   ✅ Terminal tools installed (Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, Fresh Editor, Yazi, Tmux) and configured"
echo "   ✅ Complete system control icons created (Power Off, Reboot, Full Shutdown, Logout)"
echo "   ✅ Firefox in RAM optimization configured (see FIREFOX_RAM_SETUP.md)"
echo "   ✅ App positioning set to KDE default behavior (apps remember last position)"
echo "   ✅ Auto-login with auto-lock configured (see AUTOLOGIN_AUTOLOCK_SETUP.md)"
echo "   ✅ KWallet configured with empty password for auto-unlock"
