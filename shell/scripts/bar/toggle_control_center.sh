#!/bin/bash
# Toggle control center panels

panel=$1

case $panel in
    wifi|volume|brightness)
        # Toggle control center visibility
        if eww windows | grep -q "control_center.*opened"; then
            eww close control_center
        else
            eww open control_center
        fi
        ;;
    *)
        echo "Unknown panel: $panel"
        exit 1
        ;;
esac
