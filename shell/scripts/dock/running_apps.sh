#!/bin/bash
# Monitor running apps from Hyprland

# Listen to Hyprland IPC events
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    # Get current clients
    clients=$(hyprctl clients -j)
    
    # Extract unique classes
    running=$(echo "$clients" | jq -r '.[].class' | sort -u | tr '\n' ',' | sed 's/,$//')
    
    echo "$running"
done
