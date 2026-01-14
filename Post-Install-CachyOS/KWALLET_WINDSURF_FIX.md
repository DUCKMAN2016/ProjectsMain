# KWallet Auto-Unlock Fix for Windsurf on CachyOS KDE

## Problem
Windsurf displays error: "You're running in a KDE environment but the OS keyring is not available for encryption. Ensure you have kwallet running."

Users must manually provide authentication tokens on every login instead of using the OS keyring.

## Root Cause
1. **KWallet daemon not responding via D-Bus** - Even when running, kwallet may not be accessible to applications
2. **Password mismatch** - KWallet password must match your login password for PAM auto-unlock to work
3. **No systemd service** - KWallet may not start reliably on every session

## Solution

### 1. Create Systemd User Service

Create `~/.config/systemd/user/kwalletd6.service`:

```ini
[Unit]
Description=KDE Wallet Management Tool
Documentation=man:kwalletd6(1)
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=dbus
BusName=org.kde.kwalletd6
ExecStart=/usr/bin/kwalletd6
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

Enable the service:
```bash
systemctl --user daemon-reload
systemctl --user enable kwalletd6.service
systemctl --user start kwalletd6.service
```

### 2. Verify PAM Integration

Check that `/etc/pam.d/sddm` contains:
```
-auth       optional    pam_kwallet5.so
-session    optional    pam_kwallet5.so auto_start
```

This should already be configured on CachyOS KDE.

### 3. Sync KWallet Password with Login Password

**CRITICAL**: Your kwallet password MUST match your login password for auto-unlock to work.

#### Option A: Change Wallet Password (Recommended)
```bash
kwalletmanager
```

Then:
1. Go to **Settings → Configure KWallet**
2. Select **"kdewallet"**
3. Click **"Change Password"**
4. Set it to your **exact login password**
5. Click OK

#### Option B: Reset Wallet (Clean Start)
```bash
# Backup current wallet (optional)
cp ~/.local/share/kwalletd/kdewallet.kwl ~/.local/share/kwalletd/kdewallet.kwl.backup

# Remove wallet files
rm ~/.local/share/kwalletd/kdewallet.*

# Logout and login again
# PAM will create a new wallet with your login password automatically
```

### 4. Clear Windsurf Credentials (If Needed)

If Windsurf still doesn't work after the above steps:

1. Open KWallet Manager: `kwalletmanager`
2. Navigate to **kdewallet → apps**
3. Find and delete any Windsurf-related entries
4. Close Windsurf completely
5. Reopen Windsurf and login again

### 5. Restart and Test

```bash
# Restart kwallet service
systemctl --user restart kwalletd6.service

# Verify it's running and responding
qdbus6 org.kde.kwalletd6 /modules/kwalletd6 org.kde.KWallet.isEnabled
# Should return: true

# Check service status
systemctl --user status kwalletd6.service
```

**Logout and login to your KDE session**, then test Windsurf.

## Verification

After completing all steps:

1. **Check kwallet is running**:
   ```bash
   ps aux | grep kwalletd6
   systemctl --user status kwalletd6.service
   ```

2. **Verify D-Bus communication**:
   ```bash
   qdbus6 org.kde.kwalletd6 /modules/kwalletd6 org.kde.KWallet.wallets
   # Should return: kdewallet
   ```

3. **Test Windsurf**:
   - Open Windsurf
   - Login should use kwallet automatically
   - No manual token entry required

## Why This Fix is Permanent

1. **Systemd service** ensures kwallet starts reliably every session
2. **PAM integration** unlocks kwallet automatically with your login password
3. **Password sync** allows PAM to decrypt the wallet without prompting
4. **Auto-restart** service restarts kwallet if it crashes

## Troubleshooting

### Issue: Kwallet still not working after reboot

**Solution**: Check if kwallet password matches login password
```bash
# Open wallet manager and verify password
kwalletmanager

# Check service logs
journalctl --user -u kwalletd6.service -n 50
```

### Issue: Windsurf still asks for token

**Solution**: Clear Windsurf credentials from kwallet
1. Open `kwalletmanager`
2. Delete Windsurf entries from **kdewallet → apps**
3. Restart Windsurf

### Issue: Service fails to start

**Solution**: Check for conflicting kwallet processes
```bash
# Kill all kwallet processes
killall kwalletd6

# Restart service
systemctl --user restart kwalletd6.service
```

### Issue: D-Bus errors

**Solution**: Verify D-Bus session
```bash
# Check D-Bus environment
env | grep DBUS_SESSION_BUS_ADDRESS

# If empty, restart your session
```

## Helper Script

Create `~/.local/bin/kwallet-sync-password.sh`:

```bash
#!/bin/bash
# Script to sync kwallet password with login password

echo "This script will help you sync your kwallet password with your login password."
echo "This is necessary for automatic unlocking via PAM."
echo ""
echo "Steps:"
echo "1. Open KWallet Manager"
echo "2. Go to Settings -> Configure KWallet"
echo "3. Click 'Change Password' for the 'kdewallet' wallet"
echo "4. Set the password to be the SAME as your login password"
echo ""
echo "Alternatively, you can delete the existing wallet and create a new one:"
echo "  rm ~/.local/share/kwalletd/kdewallet.*"
echo "  Then logout and login again - PAM will create a new wallet with your login password"
echo ""

read -p "Would you like to open KWallet Manager now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    kwalletmanager &
    echo "KWallet Manager opened. Please change the password to match your login password."
fi
```

Make it executable:
```bash
chmod +x ~/.local/bin/kwallet-sync-password.sh
```

## Integration with Post-Install Script

Add to `cachyos-comprehensive-post-install.sh`:

```bash
# Configure KWallet for Windsurf and other applications
echo "Configuring KWallet..."

# Create systemd user service directory
mkdir -p ~/.config/systemd/user

# Create kwalletd6 service
cat > ~/.config/systemd/user/kwalletd6.service << 'EOF'
[Unit]
Description=KDE Wallet Management Tool
Documentation=man:kwalletd6(1)
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=dbus
BusName=org.kde.kwalletd6
ExecStart=/usr/bin/kwalletd6
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Enable and start service
systemctl --user daemon-reload
systemctl --user enable kwalletd6.service
systemctl --user start kwalletd6.service

echo "✓ KWallet service configured"
echo "⚠ IMPORTANT: You must sync your kwallet password with your login password"
echo "  Run: kwalletmanager and change the password to match your login password"
```

## Additional Notes

- This fix applies to **all applications** that use KWallet, not just Windsurf
- Works with: VSCode, Chrome/Chromium, Git credential helpers, SSH key managers
- KWallet 6 (kwalletd6) is used on KDE Plasma 6
- PAM module `pam_kwallet5.so` works with both KWallet 5 and 6

## References

- KWallet Documentation: https://docs.kde.org/stable5/en/kdeutils/kwallet5/
- PAM KWallet: https://github.com/KDE/kwallet-pam
- Arch Wiki KWallet: https://wiki.archlinux.org/title/KDE_Wallet

---

**Created**: January 10, 2026  
**Tested On**: CachyOS KDE Plasma 6  
**Status**: ✅ Verified Working
