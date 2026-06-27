#!/bin/bash
# Focus existing window or launch new app

class=$1
exec_cmd=$2

# Check if app is already running
if hyprctl clients -j | jq -e ".[] | select(.class == \"$class\")" > /dev/null 2>&1; then
    # App is running, focus it
    hyprctl dispatch focuswindow "class:$class"
else
    # App not running, launch it
    $exec_cmd &
fi
