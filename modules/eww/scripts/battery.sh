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

time_remaining=$(acpi | grep -oP '\d\d(:\d\d){2}')
if [[ $? != 0 ]]; then
  time_remaining="unknown time"
fi

echo "{\"charge\":$charge,\"time_remaining\":\"$time_remaining\",\"charging\":$charging}"