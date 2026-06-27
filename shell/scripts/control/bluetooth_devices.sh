#!/bin/bash
# List paired Bluetooth devices as JSON

bluetoothctl devices | awk '
BEGIN {
    print "["
    first = 1
}
{
    if (first == 0) print ","
    first = 0
    
    mac = $2
    name = substr($0, index($0, $3))
    
    # Check if connected
    cmd = "bluetoothctl info " mac " | grep -q \"Connected: yes\""
    connected = (system(cmd) == 0) ? "true" : "false"
    
    printf "{\"mac\":\"%s\",\"name\":\"%s\",\"connected\":%s}", mac, name, connected
}
END {
    print "\n]"
}'
