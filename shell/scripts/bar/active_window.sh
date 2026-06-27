#!/bin/bash
# Get active window title from Hyprland

# Get active window info from Hyprland IPC
active=$(hyprctl activewindow -j 2>/dev/null)

if [ -z "$active" ] || [ "$active" = "Invalid" ]; then
    echo "QuishesOS"
    exit 0
fi

# Extract window title
title=$(echo "$active" | jq -r '.title' 2>/dev/null)

# If title is empty or very long, use class name instead
if [ -z "$title" ] || [ ${#title} -gt 50 ]; then
    class=$(echo "$active" | jq -r '.class' 2>/dev/null)
    
    # Capitalize first letter and clean up class name
    if [ -n "$class" ]; then
        echo "$class" | sed 's/^./\U&/' | sed 's/-/ /g'
    else
        echo "QuishesOS"
    fi
else
    # Truncate title if too long
    if [ ${#title} -gt 40 ]; then
        echo "${title:0:37}..."
    else
        echo "$title"
    fi
fi
