#!/bin/sh
# NOT YET USED! waiting for https://github.com/FieldofClay/hyprland-workspaces/issues/25

# output json string of active and occupied split-monitor-workspaces for each monitor on hyprland, e.g.
# {"HDMI-A-1":{"active":1,"occupied":[1,2,3]},"DP-1":{"active":4,"occupied":[]}}
# all workspace IDs are between 1 and 9 for split-monitor-workspaces.
# uses hyprland-workspaces https://github.com/FieldofClay/hyprland-workspaces.

# json string with active split-monitor-workspace for each monitor
# with initial value like { "DP-1": 1, "HDMI-A-1": 1 } (1-9)
active=$(hyprctl monitors -j | jq 'INDEX(.name) | map_values(1)')

hyprland-workspaces _ | while read -r line; do
    # like { "DP-1": 1 } (1-9)
    current_active=$(echo "$line" | jq 'map(select(.workspaces | any(.active == true)) | {(.name): (.workspaces[] | select(.active).id % 10)}) | add')
    # update active with current_active
    active=$(echo "$active" | jq '. + $arg' --argjson arg "$current_active")

    # TODO output occupied workspaces per monitor like [1, 2, 3] (1-9)

    echo "$active" | jq -c 'to_entries | map({(.key): {"active": .value, "occupied": []}}) | add'
done