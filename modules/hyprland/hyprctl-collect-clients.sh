#!/bin/sh
# move all hyprland clients to the current workspace

target_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# result string for hyptctl --batch
result=""

# for every hyprland client address
for address in $(hyprctl clients -j | jq -r ".[] | select (.workspace.id != $target_workspace and .workspace.id != -1) | .address"); do
    # append hyprctl command to execute with address
    result="$result dispatch movetoworkspacesilent $target_workspace,address:$address;"
done

# execute commands
hyprctl --batch $result