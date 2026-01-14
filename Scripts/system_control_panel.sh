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
    # Bring existing window to front
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
            # Use the actual refresh desktop script
            /run/media/duck/extra/User/Downloads/ProjectsMain/Scripts/refresh-desktop.sh &
            ;;
        "desktoppeek")
            # Use the actual desktop peek script
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
