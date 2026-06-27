#!/bin/bash
# Connect to WiFi network

ssid=$1

# Attempt to connect
nmcli device wifi connect "$ssid"

# Show notification
if [ $? -eq 0 ]; then
    notify-send "Wi-Fi" "Connected to $ssid" -i network-wireless
else
    notify-send "Wi-Fi" "Failed to connect to $ssid" -i network-wireless-offline -u critical
fi
