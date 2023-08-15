#!/bin/sh

# only run commands if they are not running
run() {
    # if there is no process running under the name [first argument]
    if ! pgrep -f "$1"; then
        # execute all arguments in order
        "$@" &
    fi
}

# only run commands if they are not running,
# but specify the process name to search for
#run_with_process_name() {
#    # if there is no process running under the name [first argument]
#    if ! pgrep -f "$1"; then
#        ### execute all arguments except for the first one
#        # remove first argument
#        shift 1
#        # execute all arguments
#        "$@" &
#    fi
#}

run lxpolkit
run lxqt-powermanagement
run unclutter --start-hidden --jitter 0 --timeout 3
run ulauncher --hide-window
run picom --experimental-backend
run flameshot # not necessary, but makes startup faster
run discord --start-minimized
run autokey-gtk
#run input-remapper-control --command autoload
#run $HOME/AppImages/OneDriveGUI-1.0.2.AppImage

# ask for update on saturdays
python3 /etc/nixos/nix-update/update_on_saturday.py &
