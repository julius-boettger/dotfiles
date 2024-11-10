#!/bin/sh
# output json string of active and occupied hyprsplit workspaces for each monitor on hyprland, e.g.
# {"HDMI-A-1":{"1":false,"2":true},"DP-1":{"3":true}}
# only active and occupied workspaces are listed, "true" meaning the workspace is active.
# each monitor will have exactly one (last) active workspace.
# all workspace IDs are between 1 and 9 for hyprsplit workspaces.
# uses hyprland-workspaces https://github.com/FieldofClay/hyprland-workspaces.

# json string with active hyprsplit workspace for each monitor
# with initial value like { "DP-1": 1, "HDMI-A-1": 1 } (1-9)
active=$(hyprctl monitors -j | jq -cM 'map({ (.name): 1 }) | add')

hyprland-workspaces _ | while read -r line; do
    # like { "DP-1": 1 } (1-9)
    current_active=$(jq -cM 'map(
            { (.name): (.workspaces[] | select(.active).id % 10) }
        ) | add' <<< "$line")

    # update active with current_active
    active=$(jq -cM '. + $arg' --argjson arg "$current_active" <<< "$active")

    jq -c --argjson active "$active" '
        map({
            (.name): (
                (.workspaces | map(
                    { (.id % 10 | tostring): .active }
                ) | add)
                * { ($active[.name] | tostring): true }
            )
        }) | add' <<< "$line"
done