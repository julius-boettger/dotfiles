#!/bin/sh
# open eww desktop widget on every monitor recognized by hyprland
# will open widget in background if called without arguments.
# will toggle between elevation states if called with argument "toggle".

if [ "$#" -eq 1 ] && [ "$1" = "toggle" ]; then
    # opposite of current state
    elevate=$(hyprctl layers -j | jq -c '[ to_entries | .[].value.levels."1"[] | select(.namespace == "eww-desktop-widget") | 0 ] != []')
else
    elevate="false"
fi

eww close-all

# for all monitors
hyprctl monitors -j | jq -c '.[]' | while read -r monitor; do
    model=$(echo "$monitor" | jq -r '.model')
    name=$(echo "$monitor" | jq -r '.name')

    eww open desktop --screen "$model" --id "$name" --arg "monitor=$name" --arg "elevate=$elevate"
done