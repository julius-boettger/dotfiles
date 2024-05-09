#!/bin/sh

# TODO check if internet is reachable
internet="true"

# get wired connection
nmcli device | grep ethernet | grep connected > /dev/null
if [[ $? == 0 ]]; then
  wired="true"
  signal_strength=100
else
  wired="false"
  # try to get wifi signal strength
  signal_strength=$(nmcli device wifi | grep strength | awk '{print $NF}')
fi

# fallback value for signal strength
if [ -z "${signal_strength}" ]; then
  signal_strength=0
fi

echo "{\"internet\":$internet,\"wired\":$wired,\"signal_strength\":$signal_strength}"