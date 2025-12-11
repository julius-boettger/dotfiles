#!/usr/bin/env bash

out="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

if [[ "$out" == *"[MUTED]"* ]]; then
    echo "0"
else
    percent=$(echo "$out" | grep -oP 'Volume:\s*\K[0-9]+\.[0-9]+')
    awk "BEGIN {print $percent * 100}"
fi
