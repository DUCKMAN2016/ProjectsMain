# Enpass Disable Boot Startup

## Problem
Enpass was automatically opening on system boot/login, even after attempting to disable the systemd user service.

## Root Cause
Enpass was being restored by KDE's session management system, not through a traditional autostart service. KDE Plasma saves the previous session state and restores applications when logging back in.

## Solution
Two actions were required:

### 1. Mask the systemd user service
```bash
systemctl --user mask app-Enpass@autostart.service
```
This prevents the service from starting if it were to be activated.

### 2. Remove Enpass from KDE session restore
Edit `~/.config/ksmserverrc` to remove Enpass from the saved session configurations:

- Removed Enpass entries from `[Session: saved at previous logout]`
- Removed Enpass entries from `[Session: saved by user]`
- Updated the `count` values accordingly

This ensures KDE won't attempt to restore Enpass when logging in.

## Notes
- Other applications (like Firefox) continue to restore normally
- Changes take effect on next login
- If you want Enpass to start automatically in the future, you can add it back to startup applications or session restore manually
