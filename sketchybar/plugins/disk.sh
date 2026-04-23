#!/bin/bash
# Gets used percentage of the main drive
DISK_USAGE=$(df -H / | grep '/' | awk '{print $5}')

sketchybar --set $NAME label="$DISK_USAGE"
