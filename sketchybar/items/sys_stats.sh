sketchybar --add item cpu right \
           --set cpu update_freq=2 \
                 icon="$ICON_CPU"\
                  background.drawing=off\
                  label.padding_right=5\
                  label.width=40 \
                  label.align=center\
                 script="$CONFIG_DIR/plugins/cpu.sh"

# RAM
sketchybar --add item ram right \
           --set ram update_freq=15 \
                 icon="$ICON_RAM"\
                  background.drawing=off\
                  label.width=40 \
                  label.align=center\
                 script="$CONFIG_DIR/plugins/ram.sh"

# Disk
sketchybar --add item disk right \
           --set disk update_freq=60 \
                 icon="$ICON_DISK"\
                  background.drawing=off\
                  label.padding_left=5\
                  label.width=40 \
                  label.align=center\
                 script="$CONFIG_DIR/plugins/disk.sh"

SYSTEM_ITEMS=(cpu ram disk)

# Create the bracket
sketchybar --add bracket system_stats "${SYSTEM_ITEMS[@]}" \
           --set system_stats \
                 background.border_width=1 \
                 background.drawing=on

