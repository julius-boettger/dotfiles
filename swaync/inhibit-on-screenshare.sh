#!/bin/sh
# inhibit notifications when screensharing on
# hyprland using xdph (xdg-desktop-portal-hyprland)

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    case $line in
        # when starting screenshare
        "screencast>>1"*) swaync-client -Ia "screenshare" ;;
        # when stopping screenshare
        "screencast>>0"*) swaync-client -Ir "screenshare" ;;
    esac
done