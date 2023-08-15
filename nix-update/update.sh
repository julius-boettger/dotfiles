#!/usr/bin/env fish

# read a 1-character response from user
# --silent makes response get censored like a password
read --silent --prompt-str "update? (y/n) " -n 1 response

# exit if user doesnt want to update
if test "$response" != "y"
    echo "okay :("
    exit
end

sudo echo "starting update..."

# fetch newest infos about packages and their versions
sudo nix-channel --update
# build a new configuration with the newest available versions of packages
sudo nixos-rebuild switch --upgrade-all
# clean up
sudo nix-collect-garbage

set_color green; echo "done! you can close this terminal :)"
