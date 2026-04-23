#!/bin/bash

#-----Defaults-----#
default=(
  padding_left=2
  padding_right=2
  icon.font="JetBrains Mono Nerd Font:Bold:14.0"
  label.font="JetBrains Mono Nerd Font:Bold:14.0"
  icon.color=0xffB0E313
  label.color=0xffB0E313
  background.color=0xff000000
  background.corner_radius=4
  background.height=25
  icon.padding_left=5
  icon.padding_right=0
  label.padding_left=4
)
sketchybar --default "${default[@]}"
