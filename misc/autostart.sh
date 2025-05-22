#!/bin/sh

# only run commands if they are not running
run_once() {
    # if there is no process running under the name [first argument]
    if ! pgrep -f "$1"; then
        "$@" & # execute all arguments
    fi
}

### only run some commands on xorg
# check if number of arguments is >= 1
if [ $# -ge 1 ]; then
  if [ "$1" = "xorg" ]; then
    # focus primary screen on awesome
    printf "awful=require('awful')\nawful.screen.focus(1)" | awesome-client &
    run_once unclutter --start-hidden --jitter 0 --timeout 3
    run_once nm-applet
  fi
fi

### run display server agnostic commands
# run programs in background
run_once lxpolkit > /dev/null
run_once flameshot # not necessary, but makes startup faster

# running with "run_once" is kind of not reliable +
# has built-in prevention for running more than once
copyq --start-server hide &> /dev/null &

# set default rgb profile (nothing happens if the command is not found)
openrgb --profile default > /dev/null &

### set up virtual microphone with noise reduction
NOISETORCH_MIC="alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7BVH9Y0B69B0A-00.HiFi__Mic1__source"
set_mic() {
  # set $1 as default mic with 100% volume using wireplumber id
  id=$(wpctl status | sed '/Sources:/,$ { /Streams:/q; p }' | grep -m 1 "$1" | sed "s/[^0-9]*\([0-9]\{2,\}\).*/\1/")
  if [ -z "$id" ]; then
    echo "couldnt get id for microphone '$1'"
    return
  fi
  wpctl set-default $id
  wpctl set-volume $id 100%
}
# only execute if noisetorch is not yet active (grep finds <= 1 results)
if [ "$(wpctl status | grep -c 'NoiseTorch Microphone')" -le 1 ]; then
  # wait for mics to be detected correctly
  sleep 1
  # default mic (source) to apply noise reduction to
  set_mic $NOISETORCH_MIC
  # init noisetorch for default mic
  noisetorch -i
  if [[ $? == 0 ]]; then
    echo "noisetorch activated"
  else
    echo "noisetorch couldnt be activated"
  fi
  # set noisetorch mic as default
  set_mic "NoiseTorch Microphone"
else
  echo "noisetorch already active"
fi