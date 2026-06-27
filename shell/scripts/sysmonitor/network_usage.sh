#!/bin/bash
# Get network throughput (download/upload in KB/s)

interface=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -z "$interface" ]; then
    echo "0,0"
    exit 0
fi

# Read initial values
rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)

sleep 1

# Read values after 1 second
rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)

# Calculate throughput in KB/s
rx_rate=$(echo "($rx2 - $rx1) / 1024" | bc)
tx_rate=$(echo "($tx2 - $tx1) / 1024" | bc)

echo "$rx_rate,$tx_rate"
