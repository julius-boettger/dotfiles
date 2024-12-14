#!/usr/bin/env fish

# read a 1-character response from user
# --silent makes response get censored like a password
read --silent --prompt-str "update? (y/n) " -n 1 response
if test "$response" != "y"
    echo "okay :("
    exit
end

set_color green
echo "updating flake..."
set_color white

# update flake
nix flake update --flake /etc/dotfiles

# rebuild flake with new flake.lock and given args
flake-rebuild $argv
if test $status != 0
    exit
end

set_color green
echo "completed rebuild."
set_color white

set_color green
echo "starting clean up..."
set_color white

# delete nix generations older than 7 days
sudo nix-collect-garbage --delete-older-than 14d

set_color green
echo "completed clean up."
set_color white

read --silent --prompt-str "reboot? (y/n) " -n 1 response
if test "$response" != "y"
    echo "okay :( you should reboot though! but maybe later :)"
    exit
end

reboot