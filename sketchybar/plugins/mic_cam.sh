#!/bin/bash

# Check Camera Status using system_profiler (more reliable than lsof)
CAM_ACTIVE=$(system_profiler SPCameraDataType 2>/dev/null | grep -c "In Use: Yes")

if [ "$CAM_ACTIVE" -gt 0 ]; then
  CAM_ICON="󰄀"
  CAM_COLOR=0xffed4b82
else
  CAM_ICON="󰄁"
  CAM_COLOR=0xffffffff
fi

# Check Mic Status using pgrep on coreaudiod + ioreg
MIC_ACTIVE=$(ioreg -c IOAudioEngine -r 2>/dev/null | grep -c '"IOAudioEngineState" = 1')

if [ "$MIC_ACTIVE" -gt 0 ]; then
  MIC_ICON="󰍬"
  MIC_COLOR=0xffffd60a
else
  MIC_ICON="󰍭"
  MIC_COLOR=0xffffffff
fi

sketchybar --set cam_status icon="$CAM_ICON" icon.color=$CAM_COLOR \
           --set mic_status icon="$MIC_ICON" icon.color=$MIC_COLOR
