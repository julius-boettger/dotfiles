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

# focus primary screen
printf "awful=require('awful')\nawful.screen.focus(1)" | awesome-client &

# start background programs
run_once lxpolkit
run_once unclutter --start-hidden --jitter 0 --timeout 3
run_once ulauncher --hide-window
run_once picom --experimental-backend
run_once flameshot # not necessary, but makes startup faster
run_once autokey-gtk
run_once clipster --daemon
run_once nm-applet
#run_once input-remapper-control --command autoload

# running with "run" is not reliable +
# has built-in prevention for running more than once
lxqt-powermanagement &

# set default rgb profile (nothing happens if the command is not found)
openrgb --profile default &

# ask for update on saturdays
python /etc/dotfiles/nix/update/update_on_saturday.py &
