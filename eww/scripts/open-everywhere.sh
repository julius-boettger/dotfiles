#!/bin/sh
# open eww desktop widget on every monitor recognized by hyprland
# no arguments: open widget in background
# argument "true": open widget elevated
# argument "toggle": toggle widget elevation

if [ "$1" = "toggle" ]; then
    # opposite of current state
    elevate=$(hyprctl layers -j | jq -c '[ to_entries | .[].value.levels."1"[] | select(.namespace == "eww-desktop-widget") | 0 ] != []')
elif [ "$1" = "true" ]; then
    elevate="true"
else
    elevate="false"
fi

hyprctl monitors -j | jq -c '.[] | {"name": .name, "model": .model}' | while read -r monitor; do
    name=$(jq -r '.name' <<< "$monitor")

    # open in background
    eww open desktop \
        --screen "$(jq -r '.model' <<< "$monitor")" \
        --id "$name" \
        --arg "monitor=$name" \
        --arg "elevate=$elevate" &
done

# wait for background tasks to terminate
wait