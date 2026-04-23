#!/bin/bash

# 1. Fetch network stats (runs for 1 second)
# netstat -w1 outputs a header, then the total, then the interval line.
# We want the last line (the 1-second interval).
STATS=$(netstat -w1 -I en0 | sed -n '3p')

# 2. Extract Down and Up (Columns 3 and 6)
DOWN=$(echo $STATS | awk '{print $3}')
UP=$(echo $STATS | awk '{print $6}')

function human_readable() {
    local bytes=$1
    local precision=$2
    
    # Using KiB, MiB, etc.
    if [ "$bytes" -ge 1073741824 ]; then
        printf "%.*f GiB" "$precision" "$(bc -l <<< "$bytes / 1073741824")"
    elif [ "$bytes" -ge 1048576 ]; then
        printf "%.*f MiB" "$precision" "$(bc -l <<< "$bytes / 1048576")"
    elif [ "$bytes" -ge 1024 ]; then
        printf "%.*f KiB" "$precision" "$(bc -l <<< "$bytes / 1024")"
    else
        printf "%d B" "$bytes"
    fi
}

DOWN_FORMAT=$(human_readable $DOWN 1)
UP_FORMAT=$(human_readable $UP 1)

# 3. Update Sketchybar
# Ensure network.down and network.up exist in your sketchybarrc!
sketchybar --set network.down label="⬇ $DOWN_FORMAT/s" \
           --set network.up   label="⬆ $UP_FORMAT/s"
