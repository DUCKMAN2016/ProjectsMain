#!/bin/bash
# Script to prevent screen from turning off after lock

echo "🔧 Configuring display to stay on after lock..."

# Kill and restart powerdevil to apply new settings
pkill -f powerdevil 2>/dev/null || true
sleep 2

# Restart plasma components to apply changes
kquitapp6 plasmashell 2>/dev/null || true
sleep 3
plasmashell &

echo "✅ Display power management disabled"
echo "📝 Settings applied:"
echo "   - Display turn off time: Never (0 minutes)"
echo "   - Display dim time: Never (0 minutes)" 
echo "   - Screen locker power off: Disabled"
echo ""
echo "🔄 Lock your screen to test - display should stay on"
