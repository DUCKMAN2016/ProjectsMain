#!/bin/bash

# Quick OBS Camera Fix
echo "📹 Quick OBS Camera Setup..."

# Fix permissions
echo "🔧 Fixing camera permissions..."
sudo chmod 666 /dev/video0 /dev/video1 2>/dev/null

# Add user to video group permanently
echo "👥 Adding user to video group..."
sudo usermod -a -G video $USER 2>/dev/null

# Test basic camera access
echo "📷 Testing camera access..."
if v4l2-ctl -d /dev/video0 --list-formats > /dev/null 2>&1; then
    echo "✅ Camera accessible!"
    
    echo ""
    echo "🎬 OBS STUDIO INSTRUCTIONS:"
    echo "=========================="
    echo "1. Open OBS Studio"
    echo "2. Click '+' under Sources"
    echo "3. Select 'Video Capture Device'"
    echo "4. Click 'Properties' if needed"
    echo "5. Select: 'UVC Camera (046d:0825)'"
    echo "6. If not working, try:"
    echo "   - Resolution: 640x480"
    echo "   - FPS: 30"
    echo "   - Video Format: YUYV"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "- Restart OBS after running this script"
    echo "- Try /dev/video1 if /dev/video0 doesn't work"
    echo "- Log out and back in for group changes"
    
else
    echo "❌ Camera not accessible"
    echo "Check if camera is connected and not in use by other apps"
fi

echo ""
echo "✅ Camera setup complete!"
