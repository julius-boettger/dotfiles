#!/bin/sh

charge=$(cat /sys/class/power_supply/BAT0/capacity)
if [[ $? != 0 ]]; then
  charge="100"
fi

status=$(cat /sys/class/power_supply/BAT0/status)
if [[ $? != 0 ]]; then
  status="Charging"
fi

if [[ "$status" == "Charging" ]]; then
  charging="true"
else
  charging="false"
fi

echo "{\"charge\":$charge,\"time_remaining\":\"unknown time\",\"charging\":$charging}"