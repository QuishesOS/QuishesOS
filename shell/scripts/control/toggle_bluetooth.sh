#!/bin/bash
# Toggle Bluetooth on/off

current=$(bluetoothctl show | grep "Powered:")

if echo "$current" | grep -q "yes"; then
    bluetoothctl power off
else
    bluetoothctl power on
fi
