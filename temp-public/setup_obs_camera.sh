#!/bin/bash

# Camera Setup for OBS - Fix Camera Recognition
# This script tests and configures your camera for OBS Studio

echo "📹 Setting up camera for OBS Studio..."

# Check camera device
echo "🔍 Checking camera devices..."
v4l2-ctl --list-devices

# Test camera with different formats
echo ""
echo "📷 Testing camera formats..."

echo "Testing MJPEG format (recommended for OBS)..."
ffmpeg -f v4l2 -video_size 1280x720 -input_format mjpeg -framerate 30 -i /dev/video0 -f null - -t 3 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ MJPEG format works!"
    RECOMMENDED_FORMAT="MJPEG"
    RECOMMENDED_SIZE="1280x720"
    RECOMMENDED_FPS="30"
else
    echo "❌ MJPEG format failed, trying YUYV..."
    ffmpeg -f v4l2 -video_size 640x480 -input_format yuyv422 -framerate 30 -i /dev/video0 -f null - -t 3 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ YUYV format works!"
        RECOMMENDED_FORMAT="YUYV"
        RECOMMENDED_SIZE="640x480"
        RECOMMENDED_FPS="30"
    else
        echo "❌ Camera test failed"
        exit 1
    fi
fi

# Show camera capabilities
echo ""
echo "📊 Camera Capabilities:"
v4l2-ctl -d /dev/video0 --list-formats-ext | head -20

# Create OBS configuration guide
echo ""
echo "🎬 OBS Studio Configuration:"
echo "================================"
echo "1. In OBS, click '+' under Sources"
echo "2. Select 'Video Capture Device'"
echo "3. Device: UVC Camera (046d:0825) or /dev/video0"
echo "4. Configure Video:"
echo "   - Resolution: $RECOMMENDED_SIZE"
echo "   - FPS: $RECOMMENDED_FPS"
echo "   - Video Format: $RECOMMENDED_FORMAT"
echo "   - Color Space: Default"
echo "   - Color Range: Partial"
echo ""
echo "5. If camera doesn't appear:"
echo "   - Try restarting OBS"
echo "   - Try different resolution/fps combinations"
echo "   - Try YUYV format if MJPEG fails"
echo ""

# Test camera preview (optional)
echo "🎥 Testing camera preview (5 seconds)..."
echo "You should see a camera preview window..."
ffmpeg -f v4l2 -video_size $RECOMMENDED_SIZE -input_format $(echo $RECOMMENDED_FORMAT | tr '[:upper:]' '[:lower:]') -framerate $RECOMMENDED_FPS -i /dev/video0 -f sdl -t 5 2>/dev/null || echo "Preview test completed"

echo ""
echo "✅ Camera setup complete!"
echo "🎬 Ready for OBS Studio recording!"
