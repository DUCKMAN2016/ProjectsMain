# Lock Screen Script

This script automatically locks the screen after auto-login in KDE Plasma on CachyOS.

## Setup
- Auto-login configured in `/etc/sddm.conf.d/autologin.conf`
- Script runs via KDE autostart (`~/.config/autostart/lock_screen.desktop`)
- Only locks on auto-login (detects `sddm-helper --autologin`)

## Usage
- Manual run: `./lock_screen.sh`
- Logs to `/tmp/lock_log.txt`

## Commands
- `loginctl lock-session`: Locks the session
- Delay: 5 seconds for desktop load

If issues, check logs or adjust delay.
