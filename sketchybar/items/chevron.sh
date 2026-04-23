#!bin/bash

# 1. Add and configure the Chevron (Separator)
sketchybar --add item chevron left \
           --set chevron icon="|" \
                         background.drawing=off \
                         icon.padding_left=5 \
                         icon.padding_right=5 \
                         label.drawing=off

# 2. Add and configure the Front App item
sketchybar --add item front_app left \
           --set front_app script="$PLUGIN_DIR/front_app.sh" \
                           click_script="yabai -m window --toggle float" \
                           icon.drawing=off \
                           label.padding_left=10 \
                           label.padding_right=10 \
           --subscribe front_app front_app_switched
