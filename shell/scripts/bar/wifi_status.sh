#!/bin/bash
# Get WiFi connection status

# Check if NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    echo "disconnected"
    exit 0
fi

# Get active connection
connection=$(nmcli -t -f TYPE,STATE device | grep "^wifi:connected")

if [ -n "$connection" ]; then
    echo "connected"
else
    echo "disconnected"
fi
