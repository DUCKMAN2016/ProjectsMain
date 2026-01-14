#!/bin/bash

# Script to install Razer Mouse Linux for Naga Hex support on Arch-based systems like CachyOS

# Install dependencies
echo "Installing dependencies..."
sudo pacman -S --needed unzip wget xorg-xinput xdotool

# Download the tool
cd ~
rm -rf Razer_Mouse_Linux.zip Razer_Mouse_Linux-master
wget https://codeload.github.com/lostallmymoney/Razer_Mouse_Linux/zip/refs/heads/master -O Razer_Mouse_Linux.zip
unzip Razer_Mouse_Linux.zip
cd Razer_Mouse_Linux-master

# Run install script - assuming it works on Arch
echo "Running install script..."
sh install.sh

echo "Installation complete. Run 'naga edit' to configure mappings."
