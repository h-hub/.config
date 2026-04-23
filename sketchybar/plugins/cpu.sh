#!/bin/bash
CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_LOAD=$(ps -A -o %cpu | awk -v cores=$CORE_COUNT '{s+=$1} END {printf "%.0f%%", s/cores}')
echo "CPU Load: $CPU_LOAD"
sketchybar --set $NAME label="$CPU_LOAD"
