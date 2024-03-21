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
nix flake update /etc/dotfiles/nix

### commit changes to flake.lock
# (will not do anything if file wasn't changed)
# cd into repo
set workingDir $(pwd)
cd /etc/dotfiles
# unstage possible staged changes
git reset
# commit flake.lock changes (if present)
git add nix/flake.lock
git commit -m "update flake.lock"
# stage possible changes before rebuilding so that the flake can see them
git add .
# cd back
cd $workingDir

set_color green
echo "flake updated."
set_color white

read --silent --prompt-str "rebuild? (y/n) " -n 1 response
if test "$response" != "y"
    echo "okay :("
    exit
end

set_color green
echo "rebuilding..."
set_color white

# rebuild flake with new flake.lock
flake-rebuild

set_color green
echo "completed rebuild."
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