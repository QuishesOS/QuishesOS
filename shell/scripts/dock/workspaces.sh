#!/bin/bash
# Monitor workspace changes

# Listen to Hyprland IPC for workspace events
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    if [[ "$line" == workspace* ]]; then
        # Extract workspace number
        ws=$(echo "$line" | grep -oP 'workspace>>\K\d+')
        echo "$ws"
    fi
done
