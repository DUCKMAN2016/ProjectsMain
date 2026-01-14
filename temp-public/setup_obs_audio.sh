#!/bin/bash

# Audio Setup for OBS - Yeti Mic Input Only
# This script configures audio for proper OBS recording

echo "🎤 Configuring audio for OBS Studio..."

# Set default input to Yeti microphone
echo "Setting Yeti as default input..."
pactl set-default-source alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_REV8-00.analog-stereo

# Set default output to HDMI (or speakers)
echo "Setting HDMI as default output..."
pactl set-default-sink alsa_output.pci-0000_00_14.2.hdmi-stereo

# Disable Yeti output (we only want input)
echo "Disabling Yeti output device..."
pactl suspend-sink alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_REV8-00.analog-stereo true

# Show current configuration
echo ""
echo "📊 Current Audio Configuration:"
echo "Default Input (Mic):"
pactl get-default-source
echo ""
echo "Default Output (Speakers):"
pactl get-default-sink
echo ""

# Test microphone
echo "🎙️ Testing Yeti microphone (5 seconds)..."
arecord -f cd -d 5 /tmp/yeti_test.wav
echo "✅ Microphone test saved to /tmp/yeti_test.wav"

echo ""
echo "🎬 Ready for OBS Studio!"
echo "In OBS Settings → Audio:"
echo "- Mic/Auxiliary Audio: Yeti Stereo Microphone"
echo "- Desktop Audio: HDMI/Headphones"
echo ""
echo "✨ Audio configuration complete!"
