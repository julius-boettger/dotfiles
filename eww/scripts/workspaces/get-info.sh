#!/bin/sh
# output json string of active and occupied split-monitor-workspaces for each monitor on hyprland, e.g.
# {"HDMI-A-1":{"active":1,"occupied":[1,2,3]},"DP-1":{"active":4,"occupied":[]}}
# all workspace IDs are between 1 and 9 for split-monitor-workspaces.
# the active workspace for each monitor will always be listed as occupied, even if it's not.
# uses hyprland-workspaces https://github.com/FieldofClay/hyprland-workspaces.

# json string with active split-monitor-workspace for each monitor
# with initial value like { "DP-1": 1, "HDMI-A-1": 1 } (1-9)
active=$(hyprctl monitors -j | jq 'INDEX(.name) | map_values(1)')

hyprland-workspaces _ | while read -r line; do
    # like { "DP-1": 1 } (1-9)
    current_active=$(echo "$line" | jq 'map(select(.workspaces | any(.active == true)) | {(.name): (.workspaces[] | select(.active).id % 10)}) | add')
    # update active with current_active
    active=$(echo "$active" | jq '. + $arg' --argjson arg "$current_active")

    # like { "DP-1": { "occupied": [ 1, 2, 3 ] } } (1-9)
    occupied=$(echo "$line" | jq 'map({(.name): {"occupied": [.workspaces[] | .id % 10]}}) | add')

    # output active and occupied
    echo "$active" | jq -c '(to_entries | map({(.key): {"active": .value}}) | add) * $arg' --argjson arg "$occupied"
done