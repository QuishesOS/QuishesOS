#!/bin/bash
# QuishesOS Refresh Rate Menu
# Rofi menu for selecting refresh rate

# Common refresh rates
RATES="60Hz
100Hz
120Hz
144Hz
165Hz
240Hz"

# Show rofi menu
selected=$(echo "$RATES" | rofi -dmenu -i -p "Select Refresh Rate" -theme ~/.config/rofi/quishesOS.rasi)

# Exit if cancelled
if [ -z "$selected" ]; then
    exit 0
fi

# Extract numeric value
rate_num=$(echo "$selected" | sed 's/Hz//')

# Call refresh-rate.sh
~/.config/hypr/scripts/refresh-rate.sh "$rate_num"

exit 0
