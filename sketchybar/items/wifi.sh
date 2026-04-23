sketchybar --add item wifi right                         \
           --set wifi    script="$PLUGIN_DIR/wifi.sh"    \
                         update_freq=5                   \
                          icon.padding_left=10 \
                          icon.padding_right=5 \
                          label.padding_right=10\
                          background.padding_left=5\
sketchybar --subscribe wifi wifi_change                  \
