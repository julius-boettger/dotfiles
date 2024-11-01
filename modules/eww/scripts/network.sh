#!/bin/sh

# try to reach internet (rethinkdns servers)
ping -q -c 1 -W 1 max.rethinkdns.com &> /dev/null
if [[ $? != 0 ]]; then
  echo '{"internet":false,"wired":false,"signal_strength":0,"wifi_name":""}'
  exit
fi

# test for wired connection
nmcli device | grep ethernet | grep connected &> /dev/null
if [[ $? == 0 ]]; then
  wired="true"
  signal_strength=100
else
  wired="false"
  # get wifi name and signal strength
  wifi_name=$(nmcli d | grep wifi | grep connected | sed 's/^.*connected\s*//' | head -n 1)
  signal_strength=$(nmcli d wifi | grep "^*       " | sed 's/^.*\/s\s*//' | awk '{print $1}')
  # if signal strength still unknown => 0
  if [ -z "$signal_strength" ]; then
    signal_strength=0
  fi
fi

echo "{\"internet\":true,\"wired\":$wired,\"signal_strength\":$signal_strength,\"wifi_name\":\"$wifi_name\"}"