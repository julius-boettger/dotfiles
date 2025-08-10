#!/usr/bin/env fish

nix flake update --flake /etc/dotfiles

set_color green
echo "inputs updated."
set_color white

flake-rebuild-suspend $argv
if test $status != 0
    exit
end

set_color green
echo "rebuild completed."
set_color white

read --silent --prompt-str "reboot? (y/n) " -n 1 response
if test "$response" != "y"
    echo "okay :( you should reboot though! but maybe later :)"
    exit
end

reboot