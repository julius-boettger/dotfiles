#!/bin/sh
# move all hyprland clients to a single workspace

# workspace to move clients to
target_workspace=11

# result string for hyptctl --batch
# also switch to target workspace and first workspace for other monitor
result="dispatch workspace 1; dispatch workspace $target_workspace;"

# for every hyprland client address
for address in $(hyprctl clients -j | jq -r ".[] | select (.workspace.id != $target_workspace and .workspace.id != -1) | .address"); do
    # append hyprctl command to execute with address
    result="$result dispatch movetoworkspacesilent $target_workspace,address:$address;"
done

# execute commands
hyprctl --batch $result