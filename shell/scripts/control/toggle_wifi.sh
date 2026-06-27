#!/bin/bash
# Toggle WiFi radio on/off

current=$(nmcli radio wifi)

if [ "$current" = "enabled" ]; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
