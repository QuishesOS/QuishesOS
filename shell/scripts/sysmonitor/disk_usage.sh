#!/bin/bash
# Get disk usage for all mounted drives as JSON

df -h | awk 'NR>1 && $6 !~ /^\/boot/ && $6 !~ /^\/sys/ && $6 !~ /^\/proc/ && $6 !~ /^\/dev/ && $6 !~ /^\/run/ {
    if (NR > 1 && prev != "") print ","
    
    device = $1
    size = $2
    used = $3
    avail = $4
    percent = int($5)
    mount = $6
    
    # Get mount point basename for display
    split(mount, parts, "/")
    name = (parts[length(parts)] != "") ? parts[length(parts)] : "Root"
    
    printf "{\"name\":\"%s\",\"size\":\"%s\",\"used\":\"%s\",\"avail\":\"%s\",\"percent\":%d,\"mount\":\"%s\"}", name, size, used, avail, percent, mount
    
    prev = device
}' | awk 'BEGIN{print "["} {print} END{print "]"}'
