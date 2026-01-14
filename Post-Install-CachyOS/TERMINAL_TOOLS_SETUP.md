# Terminal Tools Setup: Oh My Zsh, Powerlevel10k, Yazi, Starship, and Tmux

This document outlines the setup of powerful terminal tools for CachyOS KDE: Oh My Zsh framework, Powerlevel10k theme, syntax highlighting, autosuggestions, Yazi (file manager), Starship (prompt), and Tmux (terminal multiplexer).

## Installed Tools

### Oh My Zsh Framework
- **Description**: Feature-rich framework for Zsh with plugins and themes
- **Installation**: Cloned from GitHub to `~/.oh-my-zsh`
- **Shell**: Set as default shell with Zsh framework loaded
- **Config Location**: `~/.zshrc` - Main configuration file

### Powerlevel10k Theme
- **Description**: Fast, customizable theme with excellent path highlighting
- **Installation**: Cloned to `~/.oh-my-zsh/custom/themes/powerlevel10k`
- **Features**: Path highlighting, git status, command execution time
- **Configuration**: Interactive setup via `p10k configure`
- **Config File**: `~/.p10k.zsh`

### Zsh Plugins
- **zsh-autosuggestions**: Gray suggestions based on command history (accept with → key)
- **zsh-syntax-highlighting**: Real-time command validation with color coding
- **Color Meanings**:
  - **Green**: Valid commands (ls, cd, git, etc.)
  - **Red**: Invalid/unknown commands (typos, non-existent commands)
  - **Blue**: Valid paths and directories
  - **Cyan**: Aliases (cls for clear, etc.)
  - **Magenta**: Shell functions
  - **Yellow**: Operators and redirections

### Custom Aliases
- **cls**: Shortcut for `clear` command
- **Location**: Added to `~/.zshrc`

### Fresh Editor - Terminal Text Editor
- **Description**: Lightweight, fast terminal-based text editor with LSP support and TypeScript plugins
- **Installation**: Installed via `yay -S fresh-editor-bin` (pre-compiled binary version)
- **Features**: Multi-cursor support, LSP integration, modern interface
- **Usage**: `fresh [filename]` to open/create files, `Ctrl+S` to save, `Ctrl+Q` to quit
- **Version**: 0.1.75
- **Config**: Uses default configuration, customizable via config file

### Yazi - Terminal File Manager
- **Description**: Modern file manager written in Rust with image previews and bulk operations
- **Editor**: Configured to open files with `nano`
- **Navigation**: Vim-style keybinds (j/k for up/down, h/l for left/right)
- **Theme**: Catppuccin Mocha
- **Config Location**: `~/.config/yazi/`
  - `yazi.toml` - Main configuration
  - `keymap.toml` - Key bindings
  - `theme.toml` - Theme selection
  - `flavors/catppuccin-mocha.yazi` - Theme file

### Starship - Cross-Shell Prompt
- **Description**: Fast, customizable prompt with git status, time, and more
- **Status**: Currently disabled in favor of Powerlevel10k
- **Config Location**: `~/.config/starship.toml` (if needed later)

### Tmux - Terminal Multiplexer
- **Description**: Manage multiple terminal sessions and windows
- **Prefix Key**: Ctrl+b
- **Key Bindings**:
  - `|` - Split window vertically
  - `-` - Split window horizontally
  - `r` - Reload config
  - Alt+arrow keys - Switch panes
- **Features**: Mouse support, vi mode, Catppuccin Mocha colors
- **Config Location**: `~/.tmux.conf`

## Test Commands

In your Zsh terminal (Konsole/Yakuake):

```bash
source ~/.zshrc    # Reload Oh My Zsh configuration
whooami            # Test syntax highlighting (should appear red)
ls                 # Test valid command (should appear green)
cd Documents/      # Test path highlighting (should appear blue)
cls                # Test custom alias (should appear cyan)
fresh test.txt     # Test Fresh Editor
yazi               # Launch Yazi file manager
tmux               # Start Tmux session
p10k configure     # Reconfigure Powerlevel10k theme
```

## Autostart Configuration

Yakuake and Konsole are configured to automatically open on boot with 7 pre-configured tabs:

### Tab Configuration:
1. **yazi**: Launches the Yazi terminal file manager
2. **alt+c**: Runs fzf directory finder with eza preview (`eval $FZF_ALT_C_COMMAND | fzf $FZF_ALT_C_OPTS`)
3. **ctrl+c**: Runs eza (enhanced ls) command
4. **fresh**: Launches the Fresh terminal text editor
5. **asciiquarium**: Runs the ASCII Aquarium screensaver
6. **cmatrix**: Runs the Matrix screensaver effect
7. **bonsai**: Runs bonsai.sh tree growth animation (`bonsai.sh --live --time 0.5 --life 28 --infinite --wait 3`)

### Autostart Setup:
- Yakuake uses a custom startup script (`~/bin/yakuake_startup.sh`) with DBus calls to configure tabs
- Konsole uses `--tabs` command-line option in autostart desktop file
- Both terminal emulators are added to KDE Plasma's autostart configuration

## Installation Notes

- Oh My Zsh installed via official installer script
- Powerlevel10k cloned from GitHub to custom themes directory
- Plugins installed via git clone to custom plugins directory
- Fresh Editor installed via AUR (fresh-editor-bin package)
- All configurations created from scratch
- Compatible with CachyOS KDE Plasma
- Starship disabled to avoid conflicts with Powerlevel10k

## Usage Tips

- **Oh My Zsh**: Framework provides base functionality and plugin management
- **Powerlevel10k**: Shows current path, git status, and command results
- **Autosuggestions**: Type partial commands, press → to accept gray suggestions
- **Syntax Highlighting**: Colors help catch typos before execution
- **Fresh Editor**: Modern terminal editor with LSP support, use `fresh filename.txt`
- **Yazi**: Use `j/k` to navigate, `l` to enter directories, `h` to go back, Enter to open files
- **Tmux**: Prefix (Ctrl+b) + `c` for new window, `n` for next window, `x` to close pane

## References

- Oh My Zsh: https://ohmyz.sh/
- Powerlevel10k: https://github.com/romkatv/powerlevel10k
- zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions
- zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting
- Fresh Editor: https://github.com/fresh-editor/fresh
- Yazi: https://yazi-rs.github.io/
- Starship: https://starship.rs/
- Tmux: https://github.com/tmux/tmux/wiki

---

*Created: January 10, 2026*
*Updated: January 11, 2026 - Added autostart configuration for 7 tabs*
*Compatible: CachyOS KDE Plasma*
