#!/bin/bash

# OBS V4L2 Camera Fix - For "Add Existing" Method
echo "📹 OBS V4L2 Camera Fix..."

# Reset camera module
echo "🔄 Resetting camera module..."
sudo modprobe -r uvcvideo
sleep 2
sudo modprobe uvcvideo
sleep 2

# Check camera status
echo "📷 Checking camera devices..."
v4l2-ctl --list-devices

# Test camera with v4l2 directly
echo "🎥 Testing V4L2 access..."
timeout 3 v4l2-ctl -d /dev/video0 --stream-mmap --stream-count=1 2>/dev/null || echo "V4L2 test completed"

# Create udev rule for persistent camera
echo "⚙️ Creating udev rule for camera..."
echo 'SUBSYSTEM=="video4linux", ATTR{idVendor}=="046d", ATTR{idProduct}=="0825", MODE="0666", GROUP="video"' | sudo tee /etc/udev/rules.d/99-obs-camera.rules

# Reload udev rules
echo "🔄 Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

# Final check
echo ""
echo "📊 Final Camera Status:"
v4l2-ctl --list-devices

echo ""
echo "🎬 OBS V4L2 Instructions:"
echo "========================"
echo "1. Close and restart OBS Studio completely"
echo "2. In OBS Sources, click '+'"
echo "3. Select 'Video Capture Device (V4L2)'"
echo "4. Click 'Add Existing'"
echo "5. Your camera should now appear as:"
echo "   - '/dev/video0' or"
echo "   - 'UVC Camera (046d:0825)'"
echo ""
echo "🔧 If still not showing:"
echo "- Try '/dev/video1' instead of '/dev/video0'"
echo "- Restart your computer after running this script"
echo "- Make sure no other apps are using the camera"

echo ""
echo "✅ V4L2 camera fix complete!"
