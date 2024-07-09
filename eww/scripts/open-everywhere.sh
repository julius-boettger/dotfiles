#!/bin/sh
# open eww desktop widget on every monitor recognized by hyprland

eww close-all

# for all monitors
hyprctl monitors -j | jq -c '.[]' | while read -r monitor; do
    model=$(echo "$monitor" | jq -r '.model')
    name=$(echo "$monitor" | jq -r '.name')

    eww open desktop --screen "$model" --id "$name" --arg "monitor=$name"
done