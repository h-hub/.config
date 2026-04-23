#!/bin/bash

# The volume_change event supplies a $INFO variable with the current percentage.
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  # Determine Emoji based on Volume Level
  case "$VOLUME" in
    [6-9][0-9]|100) 
      ICON="󰕾" 
      ;;
    [3-5][0-9]) 
      ICON="󰖀" 
      ;;
    [1-9]|[1-2][0-9]) 
      ICON="󰕿" 
      ;;
    *) 
      ICON="󰝟" 
      ;;
  esac

  # Update SketchyBar
  # Added padding to prevent the "too close" look we discussed earlier
  sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$VOLUME%" \
    icon.padding_left=10 \
    icon.padding_right=5 \
    label.padding_right=10
fi
