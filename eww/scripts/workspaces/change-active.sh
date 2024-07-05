#!/bin/sh
# originally from https://wiki.hyprland.org/0.34.0/Useful-Utilities/Status-Bars/#configuration
# modified to work with split-monitor-workspaces 1-9

range() {
	min=$1
	max=$2
	val=$3
	if [ "$val" -lt "$min" ]; then
        echo "$max"
    elif [ "$val" -gt "$max" ]; then
        echo "$min"
    else
        echo "$val"
    fi
}

direction=$1

# for split-monitor-workspaces
LAST=9
current=$(expr $2 % 10)

if [ "$direction" = "down" ]; then
    hyprctl dispatch split-workspace $(range 1 $LAST $(($current + 1)))
elif [ "$direction" = "up" ]; then
    hyprctl dispatch split-workspace $(range 1 $LAST $(($current - 1)))
fi