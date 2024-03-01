#!/bin/sh
# originally from https://wiki.hyprland.org/0.34.0/Useful-Utilities/Status-Bars/#configuration
# modified to work with hyprsome workspaces (usually 1-9 and 11-19)
# accepts one argument with value 1 or 2:
# 1: observe workspaces 1 to  9
# 2: observe workspaes 11 to 19

if [ $# -ne 1 ]; then
  echo "incorrect number of arguments, expected exactly one."
  exit 1
fi

# exit if argument argument has unexpected value
if [ "$1" != "1" ] && [ "$1" != "2" ]; then 
  echo "invalid argument. expected value \`1\` or \`2\`."
  exit 1
fi

spaces() {
	LAST=9
	WORKSPACE_WINDOWS=$(hyprctl workspaces -j | jq 'map({key: .id | tostring, value: (.windows > 0)}) | from_entries')
	if   [ "$1" = "1" ]; then 
		IDS=$(seq  1       $LAST  )
	elif [ "$1" = "2" ]; then  
		IDS=$(seq 11 $((10+$LAST)))
	fi
	echo $IDS | jq --argjson occupied "${WORKSPACE_WINDOWS}" --slurp -Mc 'map(tostring) | map({id: ., occupied: ($occupied[.]//false)})'
}

spaces $1
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
	spaces $1
done