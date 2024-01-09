#!/bin/sh
# originally from https://wiki.hyprland.org/0.34.0/Useful-Utilities/Status-Bars/#configuration
# modified to work with hyprsome workspaces (usually 1-9 and 11-19)

process_current() {
  current=$1
  # echo json array with current workspace for each monitor, last active first
  if [ "$current" -gt "$LAST" ]; then
    current2=$current
    echo "[$current2, $current1]"
  else
    current1=$current
    echo "[$current1, $current2]"
  fi
}

# last hyprsome workspace
LAST=9
# current workspace for each monitor, initialize on first each
current1=1
current2=11

process_current $(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  current=$(echo $line | awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}')
  if [ -n "$current" ]; then # if not empty string
    process_current $current
  fi
done