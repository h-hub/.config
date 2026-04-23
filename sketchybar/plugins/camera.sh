#!/bin/bash

# Checks if the "AppleCamera" is currently in use
# Using ioreg to check for the 'IsActive' property
CAMERA_ACTIVE=$(ioreg -n "AppleCameraDevice" -r | grep -c "IsActive\" = Yes")

if [ "$CAMERA_ACTIVE" -gt 0 ]; then
  sketchybar --set $NAME icon="󰄀" icon.color=0xffed8796 # Red icon for active
else
  sketchybar --set $NAME icon="" # Hide icon if off
fi
