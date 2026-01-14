#!/bin/bash
# Webmin Installation Script for Ubuntu 24.04

echo "=== Installing Webmin on Ubuntu NAS ==="

# Download the setup script
echo "Downloading Webmin repository setup script..."
curl -o /tmp/setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh

# Run the setup script
echo "Setting up Webmin repository..."
sudo sh /tmp/setup-repos.sh

# Update package list
echo "Updating package list..."
sudo apt update

# Install Webmin
echo "Installing Webmin..."
sudo apt install -y webmin

# Check if UFW is active and open port if needed
if sudo ufw status | grep -q "Status: active"; then
    echo "Opening Webmin port 10000 in firewall..."
    sudo ufw allow 10000/tcp
fi

# Get the server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=== Webmin Installation Complete ==="
echo "Access Webmin at: https://${SERVER_IP}:10000"
echo "Login with your system username and password"
echo ""
