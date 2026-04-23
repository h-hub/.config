#!bin/bash

sketchybar --add item volume right                         \
           --set volume script="$PLUGIN_DIR/volume.sh"     \
            icon.padding_left=10 \
            icon.padding_right=5 \
            label.padding_right=10 \
           --subscribe volume volume_change                \
