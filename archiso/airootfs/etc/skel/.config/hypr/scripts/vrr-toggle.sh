#!/bin/bash
# QuishesOS VRR Toggle Script
# Toggles Variable Refresh Rate on/off

CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

# Check if hyprland is running
if ! pgrep -x "Hyprland" > /dev/null; then
    notify-send "QuishesOS VRR" "Hyprland is not running" -u critical
    exit 1
fi

# Get current VRR status
current_vrr=$(grep "vrr = " "$CONFIG_FILE" | tail -1 | awk '{print $3}')

# Toggle VRR
if [ "$current_vrr" = "1" ]; then
    # Disable VRR
    sed -i 's/vrr = 1/vrr = 0/' "$CONFIG_FILE"
    hyprctl keyword misc:vrr 0
    notify-send "QuishesOS Display" "VRR Disabled" -u normal -t 2000
    new_state="disabled"
else
    # Enable VRR
    sed -i 's/vrr = 0/vrr = 1/' "$CONFIG_FILE"
    hyprctl keyword misc:vrr 1
    notify-send "QuishesOS Display" "VRR Enabled" -u normal -t 2000
    new_state="enabled"
fi

echo "VRR $new_state"
exit 0
