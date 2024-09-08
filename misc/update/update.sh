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
nix flake update /etc/dotfiles

# rebuild flake with new flake.lock and given args
flake-rebuild $argv
set rebuild_status $status

# cd into repo (for git)
set working_dir $(pwd)
cd /etc/dotfiles

# if rebuild failed
if test $rebuild_status != 0
    # discard changes
    git restore nix/flake.lock
    cd $working_dir
    exit
end

set_color green
echo "completed rebuild."
set_color white

### commit changes to flake.lock
# (will not do anything if file wasn't changed)
# unstage possible staged changes
git reset
# commit flake.lock changes (if available)
git add nix/flake.lock
git commit -m "update flake.lock"
# stage possible changes before rebuilding so that the flake can see them
git add .
# cd back
cd $working_dir

set_color green
echo "committed changes to flake.lock."
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