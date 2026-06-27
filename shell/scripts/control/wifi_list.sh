#!/bin/bash
# List available WiFi networks as JSON

nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE device wifi list | head -n 20 | awk -F: '
BEGIN {
    print "["
    first = 1
}
{
    if (first == 0) print ","
    first = 0
    
    ssid = $1
    signal = $2
    security = $3
    active = $4
    connected = (active == "yes") ? "true" : "false"
    
    printf "{\"ssid\":\"%s\",\"signal\":%d,\"security\":\"%s\",\"connected\":%s}", ssid, signal, security, connected
}
END {
    print "\n]"
}'
