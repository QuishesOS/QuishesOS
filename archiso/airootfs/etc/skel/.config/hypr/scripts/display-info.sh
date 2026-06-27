#!/bin/bash
# QuishesOS Display Information Script
# Shows current display info, supported refresh rates, and VRR status

# Get monitor information from hyprctl
monitor_info=$(hyprctl monitors -j)

# Parse and display info
echo "=== QuishesOS Display Information ==="
echo ""

# Get active monitors
echo "$monitor_info" | jq -r '.[] | "Display: \(.name)\nResolution: \(.width)x\(.height)\nRefresh Rate: \(.refreshRate)Hz\nVRR: \(if .vrr then "Enabled" else "Disabled" end)\n"'

# Get supported modes from hyprctl
echo "Supported Modes:"
hyprctl monitors | grep -A 20 "active workspace" | grep "Hz" | sort -u

# Check VRR capability
vrr_supported=$(echo "$monitor_info" | jq -r '.[0].vrr')
echo ""
if [ "$vrr_supported" = "true" ]; then
    echo "✓ VRR/Adaptive Sync: Supported"
else
    echo "✗ VRR/Adaptive Sync: Not Supported"
fi

# Get current config setting
config_vrr=$(grep "vrr = " "$HOME/.config/hypr/hyprland.conf" | tail -1 | awk '{print $3}')
echo "Config Setting: VRR = $config_vrr"

echo ""
echo "=== Keybindings ==="
echo "Super+Shift+V: Toggle VRR"
echo "Super+Shift+R: Change Refresh Rate"
echo "Super+Shift+D: Display Info (this script)"

exit 0
