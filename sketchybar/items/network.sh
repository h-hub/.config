sketchybar --add item  ip_address right                              \
           --set       ip_address script="$PLUGIN_DIR/ip_address.sh" \
                                  update_freq=30                     \
                                  padding_left=2                     \
                                  padding_right=8                    \
                                  # background.border_width=0          \
                                  # background.corner_radius=6         \
                                  # background.height=24               \
                                  # icon.highlight=on                  \
                                  # label.highlight=on                 \
           --subscribe ip_address wifi_change                        \
                                                                     \
           --add item  network.up right                              \
           --set       network.up script="$PLUGIN_DIR/network.sh"    \
                                  update_freq=20                     \
                                  padding_left=2                     \
                                  padding_right=2                    \
                                  background.border_width=0          \
                                  background.height=24               \
                                  icon=⇡                             \
                                  icon.color=$YELLOW                 \
                                  label.color=$YELLOW                \
                                                                     \
           --add item  network.down right                            \
           --set       network.down script="$PLUGIN_DIR/network.sh"  \
                               update_freq=20                        \
                               padding_left=8                        \
                               padding_right=2                       \
                               background.border_width=0             \
                               background.height=24                  \
                               icon=⇣                                \
                               icon.color=$GREEN                     \
