#!/bin/sh

# try to reach internet (google dns server)
ping -q -c 1 -W 1 8.8.8.8 &> /dev/null
if [[ $? != 0 ]]; then
  echo '{"internet":false,"wired":false,"signal_strength":0}'
  exit
fi

# test for wired connection
nmcli device | grep ethernet | grep connected &> /dev/null
if [[ $? == 0 ]]; then
  wired="true"
  signal_strength=100
else
  wired="false"
  # try to get wifi signal strength
  signal_strength=$(nmcli device wifi | grep strength | awk '{print $NF}')
  # if unsuccessful: signal strength unknown => 0
  if [[ $? != 0 ]]; then
    signal_strength=0
  fi
fi

echo "{\"internet\":true,\"wired\":$wired,\"signal_strength\":$signal_strength}"