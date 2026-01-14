# MYZ80 DOSBox-X Configuration

This directory contains the optimized DOSBox-X configuration for running MYZ80 Z80/CP/M emulator.

## Files

- `myz80.conf` - DOSBox-X configuration file for MYZ80
- `myz80-dosbox-x.sh` - Launcher script
- `myz80.desktop` - Desktop icon file
- `myz80.ico` - Original MYZ80 icon (Windows format)
- `myz80.png` - Converted MYZ80 icon (Linux format)
- `README.md` - This documentation

## Configuration Details

### Window Settings
- **Resolution**: 800x600 (optimal for MYZ80 interface)
- **Position**: 2200,400 (centered on primary monitor)
- **Monitor**: Primary display (1920x1080)
- **Output**: OpenGL for better performance

### Performance Settings
- **Scaler**: normal2x (crisp text rendering)
- **Aspect correction**: Enabled
- **Auto-lock mouse**: Disabled
- **Fullscreen**: Disabled

### Auto-execution
- **Mount**: `/home/duck/myz80` as C: drive
- **Auto-start**: Launches MYZ80 automatically

## Usage

### Quick Start
```bash
# Using the desktop launcher
double-click "MYZ80" desktop icon

# Or manual launch
dosbox-x -conf ~/.config/dosbox-x/myz80.conf
```

### Customization
Edit the config file to modify:
- Window size: `windowresolution=WIDTHxHEIGHT`
- Window position: `windowposition=X,Y`
- Monitor: Add `display=N` if needed

## Installation

1. Copy `myz80.conf` to `~/.config/dosbox-x/`
2. Ensure MYZ80 files are in `/home/duck/myz80/`
3. Create desktop launcher pointing to the config

## Troubleshooting

- **Wrong monitor**: Adjust `windowposition` or add `display=N`
- **Window too small/large**: Modify `windowresolution`
- **Performance issues**: Try different `output` options (surface, overlay, opengl)

## Requirements

- DOSBox-X (not standard DOSBox)
- MYZ80 emulator files
- Linux with X11 display server
