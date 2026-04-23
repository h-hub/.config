#!bin/bash

#-----Appearance-----#
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --default icon.color=$WHITE --set background.drawing=on
sketchybar --bar corner_radius=5
sketchybar --bar position=top height=40 blur_radius=2 color=$BAR_COLOR
sketchybar --set spaces background.color=$SPACE_BACKGROUND
