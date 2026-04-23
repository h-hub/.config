#!/bin/bash
# Calculates used memory percentage
USED_MEM=$(memory_pressure | grep "System-wide memory free percentage" | awk '{printf "%d%%", 100-$5}')

sketchybar --set $NAME label="$USED_MEM"
