#!/usr/bin/env fish

# read a 1-character response from user
# --silent makes response get censored like a password
read --silent --prompt-str "update? (y/n) " -n 1 response

if test "$response" != "y"
    echo "okay :("
    exit
end

set_color green
echo "starting update..."
set_color white

# build a new configuration with the newest available versions of packages
nix flake update /etc/dotfiles/nix
flake-rebuild

set_color green
echo "completed update."
set_color white

read --silent --prompt-str "clean up? (y/n) " -n 1 response

if test "$response" != "y"
    echo "okay :("
    exit
end

set_color green
echo "starting clean up..."
set_color white

# delete nix generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

set_color green
echo "completed clean up."
set_color white

read --silent --prompt-str "reboot? (y/n) " -n 1 response

if test "$response" != "y"
    echo "okay :("
    exit
end

reboot