#!/bin/bash
# Get notification history from mako

# Mako notification database location
MAKO_HISTORY="$HOME/.local/share/mako/history"

if [ ! -f "$MAKO_HISTORY" ]; then
    echo "[]"
    exit 0
fi

# Parse mako history and output as JSON array
# Format: [{"app": "App Name", "summary": "Title", "body": "Message", "time": "5m ago"}]

# Get last 10 notifications
tail -n 20 "$MAKO_HISTORY" | awk '
BEGIN {
    print "["
    first = 1
}
{
    if (first == 0) print ","
    first = 0
    
    # Parse mako format (app-name\tsummary\tbody\ttimestamp)
    split($0, parts, "\t")
    app = parts[1]
    summary = parts[2]
    body = parts[3]
    timestamp = parts[4]
    
    # Calculate relative time
    now = systime()
    diff = now - timestamp
    if (diff < 60) time = diff "s ago"
    else if (diff < 3600) time = int(diff/60) "m ago"
    else if (diff < 86400) time = int(diff/3600) "h ago"
    else time = int(diff/86400) "d ago"
    
    printf "{\"app\":\"%s\",\"summary\":\"%s\",\"body\":\"%s\",\"time\":\"%s\"}", app, summary, body, time
}
END {
    print "\n]"
}'
