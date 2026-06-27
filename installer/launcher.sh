#!/bin/bash
# QuishesOS Installer Launcher
# Starts the installer in Firefox kiosk mode or skips to Hyprland if already installed

set -e

INSTALLER_DIR="/usr/share/quishesos-installer"
COMPLETE_FLAG="/tmp/installer-complete"

# Check if installer was already completed
if [ -f "$COMPLETE_FLAG" ]; then
    echo "Installer already completed, launching Hyprland..."
    exec Hyprland
    exit 0
fi

# Check if running in live environment
if [ ! -f "$INSTALLER_DIR/index.html" ]; then
    echo "Not in live environment, launching Hyprland..."
    exec Hyprland
    exit 0
fi

echo "Starting QuishesOS Installer..."

# Start simple HTTP server for CGI backend (if needed)
# This allows the HTML frontend to communicate with bash scripts
# cd "$INSTALLER_DIR"
# python3 -m http.server 8080 --bind 127.0.0.1 &
# HTTP_PID=$!

# Launch Firefox in kiosk mode
firefox \
    --kiosk \
    --private-window \
    --new-window \
    "file://$INSTALLER_DIR/index.html"

# Wait for Firefox to close
wait

# If we reach here, user closed Firefox - check if installation completed
if [ -f "$COMPLETE_FLAG" ]; then
    echo "Installation complete. System will reboot in 5 seconds..."
    sleep 5
    reboot
else
    echo "Installation was not completed. Launching Hyprland live environment..."
    exec Hyprland
fi
