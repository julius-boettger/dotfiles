#!/bin/sh
# originally from https://wiki.hyprland.org/0.34.0/Useful-Utilities/Status-Bars/#configuration
# modified to work with hyprsome workspaces (usually 1-9 and 11-19)

spaces() {
	LAST=9
	WORKSPACE_WINDOWS=$(hyprctl workspaces -j | jq 'map({key: .id | tostring, value: (.windows > 0)}) | from_entries')
	(seq 1 $LAST && seq 11 $((10+$LAST))) | jq --argjson occupied "${WORKSPACE_WINDOWS}" --slurp -Mc 'map(tostring) | map({id: ., occupied: ($occupied[.]//false)})'
}

spaces
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
	spaces
done