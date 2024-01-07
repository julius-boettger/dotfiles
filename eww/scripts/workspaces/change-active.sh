#!/bin/sh
# originally from https://wiki.hyprland.org/0.34.0/Useful-Utilities/Status-Bars/#configuration
# modified to work with hyprsome workspaces (usually 1-9 and 11-19)

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
current=$2
LAST=9

# 1 => 1, 11 => 1 (for hyprsome)
if [ "$current" -gt "$LAST" ]; then
	current=$(($current - 10))
fi

if [ "$direction" = "down" ]; then
    hyprsome workspace $(range 1 $LAST $(($current + 1)))
elif [ "$direction" = "up" ]; then
    hyprsome workspace $(range 1 $LAST $(($current - 1)))
fi