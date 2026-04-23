#!/bin/bash

# Fetch battery data once to save resources
BATT_INFO=$(pmset -g batt)
PERCENTAGE=$(echo "$BATT_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATT_INFO" | grep 'AC Power')
LOWPOWER=$(pmset -g | grep "lowpowermode" | awk '{print $2}')

# Exit if no percentage found
if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

# Determine Icon and Color based on percentage
case "${PERCENTAGE}" in
  9[0-9]|100) 
    ICON="󰁹" # Full
    ICON_COLOR="0xff98fb98" 
    ;;
  [7-8][0-9]) 
    ICON="󰂀" # High
    ICON_COLOR="0xffffffff" 
    ;;
  [5-6][0-9]) 
    ICON="󰁾" # Mid
    ICON_COLOR="0xffffffff" 
    ;;
  [3-4][0-9]) 
    ICON="󰁼" # Low-Mid
    ICON_COLOR="0xffffea00" 
    ;;
  [1-2][0-9]) 
    ICON="󰁻" # Low
    ICON_COLOR="0xffff5700" 
    ;;
  *) 
    ICON="󰂃" # Critical
    ICON_COLOR="0xff960019" 
    ;;
esac

# Override if Charging
if [ -n "$CHARGING" ]; then
  ICON="⚡︎"
  # Optional: Keep the green color when charging
  ICON_COLOR="0xff98fb98" 
fi

# Override color if Low Power Mode is active
if [ "$LOWPOWER" -eq 1 ]; then
  ICON_COLOR="0xffffff00"
fi

# Update SketchyBar
sketchybar --set "$NAME" \
  icon="$ICON" \
  label="${PERCENTAGE}%" \
  icon.color="$ICON_COLOR"
