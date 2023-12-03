#!/usr/bin/env fish

# read a 1-character response from user
# --silent makes response get censored like a password
read --silent --prompt-str "update? (y/n) " -n 1 response

# exit if user doesnt want to update
if test "$response" != "y"
    echo "okay :("
    exit
end

# ask for root password only once while this script is running
sudo --validate

set_color green
echo "starting update..."
set_color white

# build a new configuration with the newest available versions of packages
sudo nixos-rebuild switch --upgrade-all

set_color green
echo "completed update."
set_color white

read --silent --prompt-str "type any character to start cleaning up: " -n 1

set_color green
echo "cleaning up..."
set_color white

# delete nix generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

set_color green
echo "done! you can close this terminal :)"
