#!/bin/bash
# Clear all notifications from mako history

# Mako control command
makoctl dismiss --all

# Clear history file
MAKO_HISTORY="$HOME/.local/share/mako/history"
if [ -f "$MAKO_HISTORY" ]; then
    > "$MAKO_HISTORY"
fi

echo "Cleared all notifications"
