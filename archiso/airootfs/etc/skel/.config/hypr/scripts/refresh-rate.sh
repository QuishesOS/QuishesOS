#!/bin/bash
# QuishesOS Refresh Rate Switcher
# Changes display refresh rate

if [ $# -eq 0 ]; then
    echo "Usage: $0 <refresh_rate>"
    echo "Example: $0 120"
    exit 1
fi

RATE=$1
CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

# Check if hyprland is running
if ! pgrep -x "Hyprland" > /dev/null; then
    notify-send "QuishesOS Display" "Hyprland is not running" -u critical
    exit 1
fi

# Get current monitor
monitor_info=$(hyprctl monitors -j | jq -r '.[0]')
monitor_name=$(echo "$monitor_info" | jq -r '.name')
current_width=$(echo "$monitor_info" | jq -r '.width')
current_height=$(echo "$monitor_info" | jq -r '.height')

# Check if rate is supported (basic check)
if [ "$RATE" -lt 30 ] || [ "$RATE" -gt 240 ]; then
    notify-send "QuishesOS Display" "Invalid refresh rate: ${RATE}Hz\nMust be between 30-240Hz" -u critical
    exit 1
fi

# Apply new refresh rate
hyprctl keyword monitor "${monitor_name},${current_width}x${current_height}@${RATE},auto,1"

# Check if successful
if [ $? -eq 0 ]; then
    notify-send "QuishesOS Display" "Refresh rate changed to ${RATE}Hz" -u normal -t 3000
    
    # Update config for persistence (optional - commented out to avoid permanent changes)
    # sed -i "s/monitor=,preferred,auto,1/monitor=,${current_width}x${current_height}@${RATE},auto,1/" "$CONFIG_FILE"
    
    echo "Successfully changed to ${RATE}Hz"
    exit 0
else
    notify-send "QuishesOS Display" "Failed to change refresh rate\n${RATE}Hz may not be supported" -u critical
    echo "Failed to change refresh rate"
    exit 1
fi
