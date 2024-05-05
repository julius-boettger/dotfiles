#!/bin/sh

charge=$(cat /sys/class/power_supply/BAT0/capacity)

status=$(cat /sys/class/power_supply/BAT0/status)
if [[ "$status" == "Charging" ]]; then
  charging="true"
else
  charging="false"
fi

echo "{\"charge\":$charge,\"time_remaining\":\"unknown time\",\"charging\":$charging}"