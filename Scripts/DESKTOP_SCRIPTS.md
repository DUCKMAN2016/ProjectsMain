# Desktop Peek Scripts

A collection of Bash scripts for KDE Plasma that provide a "Peek at Desktop" functionality by combining desktop icon hiding with KDE's built-in window minimization.

## Features

- **Peek at Desktop**: Hide desktop icons and minimize all open windows for a clean desktop view
- **Restore Desktop**: Show desktop icons again and restore all minimized windows
- **Multi-Monitor Support**: Works across all monitors (primary and secondary)
- **Wayland Compatible**: Uses KDE's native Peek at Desktop functionality
- **Taskbar Integration**: Desktop launchers that can be pinned to your taskbar
- **Safe File Handling**: Icons are temporarily moved to a hidden directory, not deleted
- **One-Click Toggle**: Single script that toggles between peek and normal states

## Scripts

### hide_desktop_icons.sh
- Temporarily moves all desktop files to `~/.desktop_hidden`
- Triggers KDE's built-in Peek at Desktop (minimizes all windows)
- Provides instant clean desktop view

### show_desktop_icons.sh
- Triggers KDE's built-in Peek at Desktop (restores all windows)
- Moves desktop files back from `~/.desktop_hidden`
- Returns desktop to normal state

### toggle_desktop_peek.sh
- Single script that toggles between peek and normal modes
- Automatically detects current state
- Uses KDE's native Peek at Desktop functionality

### desktop_peek_unified.sh (Recommended)
- **One-click toggle** with desktop notifications
- **Taskbar launcher** with icon for pinning
- **Combines everything**: icons + windows + notifications
- **Silent operation** (no terminal output)
- **Best user experience** for everyday use

## Installation

1. **Clone/Download Scripts**:
   ```bash
   # Scripts are located in:
   ~/Downloads/ProjectsMain/Scripts/
   ```

2. **Make Executable**:
   ```bash
   cd ~/Downloads/ProjectsMain/Scripts/
   chmod +x hide_desktop_icons.sh show_desktop_icons.sh toggle_desktop_peek.sh desktop_peek_unified.sh
   ```

3. **Desktop Launchers** (Optional):
   - Launchers are already created in `~/.local/share/applications/`
   - Search for "Peek at Desktop" and "Restore Desktop" in application menu
   - **Search for "Desktop Peek" for the unified one-click launcher**
   - Right-click → Pin to Task Manager

## Usage

### Command Line
```bash
# Hide desktop icons and minimize windows
./hide_desktop_icons.sh

# Show desktop icons and restore windows
./show_desktop_icons.sh

# Toggle between peek and normal (recommended)
./toggle_desktop_peek.sh

# One-click unified toggle with notifications (best for taskbar)
./desktop_peek_unified.sh
```

### Taskbar Integration
- Pin the launchers to your KDE taskbar for quick access
- Click "Peek at Desktop" to hide icons and minimize windows
- Click "Restore Desktop" to bring everything back
- **Or pin "Desktop Peek" for one-click toggling (recommended)**

## Requirements

- **KDE Plasma 6** (tested on Plasma 6.5.3)
- **wmctrl** (for window state control)
- **libnotify** (for desktop notifications in unified script)
- **Bash** shell
- **Standard Linux file utilities** (mv, ls, mkdir, rmdir)

## How It Works

### Hide Process
1. Creates `~/.desktop_hidden` directory if needed
2. Moves all files from `~/Desktop/` to hidden directory
3. Uses `wmctrl -k on` to minimize all windows
4. Shows clean desktop view
5. Reports success

### Restore Process
1. Uses `wmctrl -k off` to restore all windows
2. Moves files back from `~/.desktop_hidden` to `~/Desktop/`
3. Removes empty hidden directory
4. Reports success

### Toggle Process
1. Checks if currently in peek mode (reads `~/.desktop_peek_state`)
2. If hidden: performs restore actions
3. If normal: performs hide actions
4. Updates state file

### Unified Process (Recommended)
1. One-click toggle with visual feedback
2. Desktop notifications: "Desktop Peek Active" / "Desktop Restored"
3. Silent operation, no terminal needed
4. Best for taskbar pinning

## Safety Features

- **No Data Loss**: Files are moved, not deleted
- **Atomic Operations**: Either succeeds completely or fails safely
- **Hidden Storage**: Uses dot directory to avoid accidental discovery
- **State Tracking**: Toggle script tracks current state to prevent errors

## Multi-Monitor Support

The scripts work across all monitors by leveraging KDE's built-in Peek at Desktop functionality:
- **Primary Monitor**: Works with KDE's native window management
- **Secondary Monitors**: KDE's Peek at Desktop handles all monitors
- **Wayland Compatible**: Uses keyboard shortcuts that work on Wayland

## Troubleshooting

### Scripts Not Working
- Ensure scripts are executable: `chmod +x *.sh`
- Check wmctrl is available: `which wmctrl`
- Run as regular user (not root): Scripts include root detection
- Verify KDE Plasma version: `plasmashell --version`

### KDE Peek at Desktop Not Working
- Check that Super+d shortcut is assigned: System Settings → Shortcuts → Global Shortcuts → Peek at Desktop
- Try manually pressing Super+d to test
- Verify the showdesktop widget is in your taskbar

### Icons Not Hiding
- Verify Desktop directory exists: `ls ~/Desktop/`
- Check hidden directory: `ls ~/.desktop_hidden/`

### Launchers Not Appearing
- Update desktop database: `kbuildsycoca6`
- Check launcher files: `ls ~/.local/share/applications/*desktop*`

## Customization

### Change Keyboard Shortcut
If your KDE Peek at Desktop uses a different shortcut:
```bash
# Edit scripts and replace "Super+d" with your shortcut
xdotool key "your_shortcut_here"
```

### Change Hidden Directory
Edit the scripts to use a different hidden location:
```bash
HIDDEN_DIR="$HOME/.my_hidden_desktop"
```

## Differences from Manual Peek at Desktop

**KDE Built-in Peek at Desktop:**
- Only minimizes windows, icons remain visible
- No icon hiding functionality
- Cannot be combined with other actions

**These Scripts:**
- Combines icon hiding + window minimization
- Provides toggle functionality
- Can be scripted and automated
- Works with both individual and toggle scripts

## Version History

### v2.0 - Unified Solution (Current)
- Added `desktop_peek_unified.sh` - one-click toggle with notifications
- Added desktop launcher with icon for taskbar pinning
- Simplified approach using KDE's built-in Peek at Desktop
- Multi-monitor support across all displays
- Wayland compatible

### v1.0 - Basic Functionality
- Icon hiding/showing functionality
- Window minimization/restore
- Taskbar integration
- State tracking

## Quick Start (Recommended)

**For everyday use:**
1. Search for "Desktop Peek" in application menu
2. Pin it to your taskbar
3. Click once to peek, click again to restore
4. Get desktop notifications for feedback

## License

These scripts are provided as-is for personal use. Modify and distribute as needed.

## Author

Created for KDE Plasma desktop management, combining icon hiding with native KDE functionality.
