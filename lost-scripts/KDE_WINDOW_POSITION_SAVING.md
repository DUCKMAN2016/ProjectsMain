# KDE Window Position Saving - CachyOS

## Overview
KDE Plasma can automatically save and restore window positions using KWin scripts or window rules. This is handled by the window manager, not Wayland directly.

---

## Method 1: KWin Script "Remember Window Positions" (Recommended)

This is the easiest method for automatic window position saving across all applications.

### Installation Steps:

1. **Open System Settings**
   - Click the Application Launcher
   - Search for "System Settings"

2. **Navigate to KWin Scripts**
   - Go to **Window Management** → **KWin Scripts**

3. **Get New Scripts**
   - Click the **"Get New Scripts..."** button (top-right corner)
   - In the search box, type: **"Remember Window Positions"** or **"Save Window Geometry"**

4. **Install the Script**
   - Find the script in the results (common ones: "Save Window Geometry", "Window Geometry")
   - Click **Install** button
   - Wait for installation to complete

5. **Enable the Script**
   - Back in the KWin Scripts menu, find the newly installed script
   - **Check the box** next to the script name to enable it
   - Click **Apply** at the bottom

6. **Configure (Optional)**
   - Click the **Configure** icon (gear/wrench) next to the script
   - Adjust settings like:
     - Which windows to remember
     - Save frequency
     - Restore behavior

### How It Works:
- Automatically saves window positions when you move/resize windows
- Restores positions when applications launch
- Works across reboots and logout/login cycles

---

## Method 2: KDE Session Management

KDE has built-in session management that can save window positions on logout.

### Enable Session Restore:

1. **Open System Settings**
2. Go to **Startup and Shutdown** → **Desktop Session**
3. Under "On Login", select one of:
   - **"Restore previous session"** - Saves all windows on logout, restores on login
   - **"Restore manually saved session"** - Only restores manually saved sessions

4. Click **Apply**

### Manual Session Save:
- To manually save current window layout:
  - Press **Alt+F2** to open KRunner
  - Type: `qdbus org.kde.ksmserver /KSMServer saveCurrentSession`
  - Or use the menu: **Session** → **Save Session** (if available)

### Important Notes:
- Session management saves on **logout**, not on reboot
- For best results, always **logout before rebooting**
- Reboot without logout may not save window positions

---

## Method 3: KWin Window Rules (Per-Application)

For granular control over specific applications, create custom window rules.

### Steps:

1. **Open the Application** you want to configure

2. **Access Window Rules**
   - Right-click the **title bar** of the application window
   - Select **More Actions** → **Configure Special Application Settings...**
   
   OR
   
   - Open **System Settings** → **Window Management** → **Window Rules**
   - Click **Add New...**

3. **Add Position/Size Rule**
   - Click **+ Add Property...**
   - Select **Position** and/or **Size**
   - Set the rule to:
     - **Remember**: To save current position
     - **Apply Initially**: To set a specific position
     - **Force**: To always use this position

4. **Configure the Rule**
   - Set the desired position (X, Y coordinates)
   - Set the desired size (Width, Height)
   - Choose when to apply the rule

5. **Click OK** and **Apply**

### Example Use Cases:
- Force terminal to always open in bottom-right corner
- Keep browser maximized on specific monitor
- Position IDE on secondary display

---

## Method 4: Alternative - Dynamic Tiling

If you prefer automatic window organization without manual positioning:

### Krohnkite (KDE Tiling Extension)

1. **Install Krohnkite**:
   ```bash
   yay -S kwin-scripts-krohnkite
   ```

2. **Enable in System Settings**:
   - Go to **Window Management** → **KWin Scripts**
   - Enable **Krohnkite**
   - Click **Apply**

3. **Configure Tiling**:
   - Click the configure icon next to Krohnkite
   - Set tiling layouts and behavior

### Hyprland (Alternative Compositor)
- A dynamic tiling Wayland compositor
- Requires switching from KDE Plasma
- See: `/run/media/duck/extra/User/Downloads/ProjectsMain/GITHUB/` for Hyprland configs

---

## Troubleshooting

### Windows Not Restoring Position

**Check if KWin script is enabled:**
```bash
kreadconfig6 --file kwinrc --group Plugins --key rememberwindowpositionsEnabled
```

**Enable manually if needed:**
```bash
kwriteconfig6 --file kwinrc --group Plugins --key rememberwindowpositionsEnabled true
qdbus org.kde.KWin /KWin reconfigure
```

### Session Not Saving

**Verify session management setting:**
```bash
kreadconfig6 --file ksmserverrc --group General --key loginMode
```

**Set to restore previous session:**
```bash
kwriteconfig6 --file ksmserverrc --group General --key loginMode "restorePreviousLogout"
```

### Script Not Working After Install

1. **Restart KWin:**
   ```bash
   kwin_wayland --replace &
   ```
   
   Or logout and login again

2. **Check script is actually enabled:**
   - System Settings → Window Management → KWin Scripts
   - Verify checkbox is checked
   - Click Apply again

---

## Recommended Setup for CachyOS

For the best window position management experience:

1. ✅ **Install "Remember Window Positions" KWin script** (Method 1)
   - Automatic, works for all applications
   - No manual intervention needed

2. ✅ **Enable "Restore previous session"** (Method 2)
   - Backup method for session restore
   - Saves entire desktop state

3. ✅ **Create window rules for critical apps** (Method 3)
   - Terminal emulators (Yakuake, Konsole)
   - IDE/Editors (Windsurf, Kate)
   - Browsers (if you want specific positioning)

4. ✅ **Always logout before reboot**
   - Ensures session is saved properly
   - Prevents position loss

---

## Current System Status

**Yakuake**: ✅ Auto-starts with 7 configured tabs  
**Session Management**: ⚠️ Not yet configured  
**Window Position Script**: ⚠️ Not yet installed  

**Next Steps:**
1. Install "Remember Window Positions" KWin script via System Settings
2. Enable "Restore previous session" in Desktop Session settings
3. Test by moving windows, logging out, and logging back in

---

## Additional Resources

- **KDE Window Management Docs**: https://userbase.kde.org/KWin
- **KWin Scripts**: https://store.kde.org/browse?cat=210
- **Window Rules Guide**: https://userbase.kde.org/KWin_Rules

---

**Created**: January 12, 2026  
**Purpose**: Guide for configuring automatic window position saving in KDE Plasma on CachyOS  
**Status**: Manual installation required via System Settings GUI
