# [NixOS](https://nixos.org/) configuration and other dotfiles
> These dotfiles are what I daily drive at home, so you can be sure that they (kind of) work

### Credit
- My [awesome](https://awesomewm.org/) config is based on the "rainbow" theme of [awesome-copycats](https://github.com/lcpz/awesome-copycats), which I then modified to fit my taste and needs
- My wallpaper is a modified version of `nix-wallpaper-nineish-dark-gray` of [nixos-artwork](https://github.com/NixOS/nixos-artwork)

# Installation & Usage

- Most of these dotfiles can be used independently of the others, like `picom.conf` for configuring [picom](https://github.com/jonaburg/picom). You are free to use just parts the parts you like as they suit you.
    - See [Overview](#overview) for explanations of files and directories.
- The following guide explains installation on a [NixOS](https://nixos.org/) system (which is my use case).
- 🚨 This guide assumes that you have either backed up your config files or don't care about them, as it may override or delete them.
- 🚨 There is some stuff in here that is not prepared to be used by anyone else besides me, so you are **strongly advised** to look through these files on your own before using them.

Add channels for a stable NixOS release and [home-manager](https://github.com/nix-community/home-manager) (versions like `23.05` might need adjustment):
```shell
# check subscribed channels
sudo nix-channel --list # should show that no channels are subscribed (otherwise you should remove them)
# add channels
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
# update
sudo nix-channel --update
sudo nixos-rebuild switch
```
Place the content of this repository inside `/etc/nixos`. A rough way to do this (assuming you have the necessary permissions) is:
```shell
cd /tmp
git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git
cp -r dotfiles/* /etc/nixos
```
Make sure to carefully inspect `configuration.nix` and edit it as needed before rebuilding, as you may not want e.g. NVIDIA drivers or the username `julius`. Then rebuild your system (e.g. `sudo nixos-rebuild switch`).

As setting GTK themes with home-manager didn't work for me, I set them with `lxappearance`. Go ahead and do that.

If you want to use [circadian](https://github.com/mrmekon/circadian), I found it easiest to manually build it and place the executable under `~/.local/bin`. My `configuration.nix` should take care of the rest (writing a config file and setting up a systemd-service).

# Overview

> ### 🛠 Under Development
