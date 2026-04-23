#!/bin/bash

# Icons
ICON_WIFI="󰤨"
ICON_ETHERNET="󰈀"
ICON_DISCONNECTED="󰤭"

# 1. Check Ethernet (usually en0 or en1 depending on Mac model)
# We look for a hardware port named 'Ethernet' or 'LAN' that has an active IP
ETH_DEVICE=$(networksetup -listallhardwareports | grep -A1 "Ethernet" | grep "Device" | awk '{print $2}')
ETH_IP=$(ipconfig getifaddr "$ETH_DEVICE")

# 2. Check Wi-Fi
WIFI_DEVICE=$(networksetup -listallhardwareports | grep -A1 "Wi-Fi" | grep "Device" | awk '{print $2}')
WIFI_IP=$(ipconfig getifaddr "$WIFI_DEVICE")
SSID=$(networksetup -getairportnetwork "$WIFI_DEVICE" | awk -F": " '{print $2}')

# --- LOGIC ---

if [ -n "$ETH_IP" ]; then
  # If Ethernet has an IP, prioritize it
  sketchybar --set "$NAME" \
    icon="$ICON_ETHERNET" \
    label="Ethernet"

elif [ -n "$WIFI_IP" ] && [[ "$SSID" != *"not associated"* ]]; then
  # If no Ethernet, check if Wi-Fi is associated and has an IP
  sketchybar --set "$NAME" \
    icon="$ICON_WIFI" \
    label="Wifi"

else
  # Nothing is connected
  sketchybar --set "$NAME" \
    icon="$ICON_DISCONNECTED" \
    label="Offline"
fi
