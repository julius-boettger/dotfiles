# [NixOS](https://nixos.org/) configuration and other dotfiles
> These dotfiles are what I daily drive at home, so you can be sure that they (kind of) work

### Credit
- My [awesome](https://awesomewm.org/) config is based on the "rainbow" theme of [awesome-copycats](https://github.com/lcpz/awesome-copycats), which I then modified to fit my taste and needs
- My wallpaper is a modified version of `nix-wallpaper-nineish-dark-gray` of [nixos-artwork](https://github.com/NixOS/nixos-artwork)

# Screenshots / Showcase (version [v1.0.0](https://github.com/julius-boettger/dotfiles/releases/tag/v1.0.0))
https://github.com/julius-boettger/dotfiles/assets/85450899/4f33b2a8-80b3-47ff-8cc9-b1298d3d5de2
<p align="middle">
  <img src=".github/assets/screenshot1.png" width="49%" />
  <img src=".github/assets/screenshot2.png" width="49%" /> 
</p>

# Content overview
> Note: "Recommended directory" is the path to the directory where the described file (or directory) is usually located. This is either just `/etc/nixos/`, because this repository is assumed to be there, or another path, where a dotfile will be symlinked. See [`nix-packages/symlink-dotfiles.nix`](https://github.com/julius-boettger/dotfiles/blob/main/nix-packages/symlink-dotfiles.nix) for the script that should create those symlinks.

| File or directory | Recommended directory | Description |
|-------------------|-----------------------|-------------|
| `configuration.nix` | `/etc/nixos/` | [NixOS](https://nixos.org) configuration |
| `nix-update/` | `/etc/nixos/` | Scripts to automatically update and clean up [NixOS](https://nixos.org) after a prompt every saturday |
| `nix-packages/` | `/etc/nixos/` | Self-written derivations for Nix packages |
| `awesome/` | `~/.config/` | Configuration for [Awesome](https://github.com/awesomeWM/awesome) including a theme based on [awesome-copycats](https://github.com/lcpz/awesome-copycats)' "rainbow" theme |
| `picom.conf` | `~/.config/` | Configuration for [picom (`jonaburg`-fork)](https://github.com/jonaburg/picom) |
| `ulauncher/` | `~/.config/` | Configuration for [Ulauncher](https://github.com/Ulauncher/Ulauncher/) including a custom color theme |
| `firefox.css` | `~/.mozilla/firefox/[YOUR-PROFILE]/chrome/` | `userChrome.css` for theming [Firefox](https://www.mozilla.org/en-US/firefox/new/) |
| `sddm-sugar-candy/` | `/usr/share/sddm/themes/` (somewhere in `/nix/store/` on NixOS) | Configuration for [sddm-sugar-candy](https://github.com/Kangie/sddm-sugar-candy) |
| `.ideavimrc` | `~/` | Like `.vimrc`, but for [IntelliJ IDEA](https://github.com/JetBrains/intellij-community) using [IdeaVim](https://github.com/JetBrains/ideavim) |
| `autokey-phrases/` | `~/.config/autokey/` | Phrases for [AutoKey](https://github.com/autokey/autokey) to make `Ctrl+Alt` act like `AltGr` for some keys like they do on Windows with a German keyboard layout |

# Installation & usage

- Most of these dotfiles can be used independently of the others, like `picom.conf` for configuring [picom](https://github.com/jonaburg/picom). You are free to use just parts the parts you like as they suit you.
    - See [Content overview](#content-overview) for explanations of files and directories.
- The following guide explains installation on a [NixOS](https://nixos.org/) system (which is my use case).
- ⚠️ Knowledge of basic [NixOS](https://nixos.org/) usage is needed. Try it out first before attempting to follow this guide.
- ⚠️ This guide assumes that you have either backed up your config files or don't care about them, as it may override or delete them.
- 🚨 There is some stuff in here that is not prepared to be used by anyone else besides me, so you are **strongly advised** to look through these files on your own before using them.

First install [NixOS](https://nixos.org/) and set it up far enough to have `git`, a network connection and a text editor available.

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
Place the content of this repository inside `/etc/nixos`. This is necessary as many paths in the configuration rely on it. A possible way to do this (assuming you have the necessary permissions) is:
```shell
cd /tmp
git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git
cp -rf dotfiles/* /etc/nixos
```
Make sure to carefully inspect `configuration.nix` and edit it as needed before rebuilding, as you may not want e.g. NVIDIA drivers or the username `julius`.

Other configuration files may also contain hardware specific code, like `xrandr` commands in `awesome/rc.lua`, which are for my specific monitor setup. These shouldn't break anything right away though (famous last words), so you may fix them as you go.

Then:
```shell
# rebuild your system, e.g.
sudo nixos-rebuild switch
# create symlinks to put dotfiles in their respective locations
# this runs a script that I've written, see nix-packages/symlink-dotfiles.nix
# if this outputs something like "cannot overwrite directory" you might need to manually remove that directory and try again
symlink-dotfiles 
# reboot for good measure
reboot
```

Finally some [Ulauncher](https://github.com/Ulauncher/Ulauncher/) extensions: Open Ulauncher with `Super+R` and click on the little gear to access the settings. Then go to the tab EXTENSIONS and install the following extensions by clicking on "Add extension" and entering a Github-link:
```
https://github.com/Ulauncher/ulauncher-emoji
https://github.com/iboyperson/ulauncher-system
https://github.com/ulauncher-extensions/ulauncher-conversion
```
You might need to click on "Reload the list" or restart Ulauncher (`pkill ulauncher && ulauncher &`) for the changes to take effect.

And then you should be all set up! Feel free to reach out if there's something missing, misleading or incorrect in this installation guide.