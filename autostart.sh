#!/bin/sh

# only run commands if they are not running
run_once() {
    # if there is no process running under the name [first argument]
    if ! pgrep -f "$1"; then
        "$@" & # execute all arguments
    fi
}

# only run commands if they are not running,
# but specify the process name to search for
run_once_with_pname() {
    # if there is no process running under the name [first argument]
    if ! pgrep -f "$1"; then
        ### execute all arguments except for the first one
        shift 1 # remove first argument
        "$@" & # execute all arguments
    fi
}

### only run some commands on xorg/wayland
# check if number of arguments is >= 1
if [ $# -ge 1 ]; then
  if [ "$1" = "xorg" ]; then
    ### only run on xorg
    # focus primary screen on awesome
    printf "awful=require('awful')\nawful.screen.focus(1)" | awesome-client &
    run_once unclutter --start-hidden --jitter 0 --timeout 3
    run_once picom --experimental-backend
    run_once flameshot # not necessary, but makes startup faster
  elif [ "$1" = "wayland" ]; then
    ### only run on wayland
    run_once swaync
  fi
fi

### run display server agnostic commands
# run programs in background
run_once lxpolkit
run_once ulauncher --hide-window
run_once nm-applet
run_once copyq --start-server hide

# running with "run_once" is not reliable +
# has built-in prevention for running more than once
lxqt-powermanagement &

# set default rgb profile (nothing happens if the command is not found)
openrgb --profile default &

# ask for update on saturdays
python /etc/dotfiles/nix/update/update_on_saturday.py &
