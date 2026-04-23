#!bin/bash

sketchybar --add item battery right                        \
           --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
            icon.padding_left=10 \
            icon.padding_right=5 \
            label.padding_right=10 \
           --subscribe battery system_woke power_source_change
