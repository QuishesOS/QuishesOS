#!/bin/bash
# Auto-start Hyprland on login for live user

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    # Display nova-info on first login
    nova-info
    echo ""
    echo "Starting Hyprland in 3 seconds..."
    echo "Press Ctrl+C to cancel"
    sleep 3
    
    exec Hyprland
fi
