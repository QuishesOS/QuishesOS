#!/bin/bash
# Get CPU usage samples for sparkline

# Collect 60 samples of CPU usage
samples=()
for i in {1..60}; do
    cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int(100 - $1)}')
    samples+=($cpu)
    
    # Only sleep if not last iteration
    if [ $i -lt 60 ]; then
        sleep 1
    fi
done

# Output as comma-separated values
echo "${samples[@]}" | tr ' ' ','
