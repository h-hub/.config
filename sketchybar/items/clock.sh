#!bin/bash

sketchybar --add item clock right                          \
           --set clock update_freq=1 script="$PLUGIN_DIR/clock.sh" \
           --set clock background.drawing=on               \
            icon.padding_left=10 \
            icon.padding_right=5 \
            label.width=160 \
            label.padding_right=10 \
            label.align=center


