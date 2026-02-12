#!/bin/sh
# call with argument "-" or "+" for previous or next workspace

# outputs (hyprsplit) workspace between 1 and 9,
# cycling/wrapping around, of the focused monitor
hyprctl monitors -j | jq -cM "
    .[]
    | select(.focused)
    | .activeWorkspace.id
    | if . > 10 then . - 10 else . end
    | . $1 1
    | if . < 1 then 9 else . end
    | if . > 9 then 1 else . end
"
