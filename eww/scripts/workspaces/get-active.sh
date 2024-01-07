#!/bin/sh
# from https://wiki.hyprland.org/0.34.0/Useful-Utilities/Status-Bars/#configuration

hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'