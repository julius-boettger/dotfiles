# [NixOS](https://nixos.org/) configuration and other dotfiles

### Credit
- My [Awesome](https://awesomewm.org/) config is based on the "rainbow" theme of [awesome-copycats](https://github.com/lcpz/awesome-copycats)
- My [Rofi](https://github.com/lbonn/rofi) themes are based on the "rounded" theme of [rofi-themes-collection](https://github.com/newmanls/rofi-themes-collection)
- The wallpapers in `wallpapers/nixos/` are modified versions of `nix-wallpaper-nineish-dark-gray` of [nixos-artwork](https://github.com/NixOS/nixos-artwork)

# Screenshots / Showcase
### [v2.0.0](https://github.com/julius-boettger/dotfiles/releases/tag/v2.0.0)
https://github.com/julius-boettger/dotfiles/assets/85450899/6cf57c22-b1bf-4ba0-9eb9-cc55d3327345
<p align="middle">
  <img src=".github/assets/v2.0.0/screenshot1.png" width="49%" />
  <img src=".github/assets/v2.0.0/screenshot2.png" width="49%" /> 
</p>
(also still contains the setup of v1.0.0, but with slight modifications)

### [v1.0.0](https://github.com/julius-boettger/dotfiles/releases/tag/v1.0.0)
https://github.com/julius-boettger/dotfiles/assets/85450899/4f33b2a8-80b3-47ff-8cc9-b1298d3d5de2
<p align="middle">
  <img src=".github/assets/v1.0.0/screenshot1.png" width="49%" />
  <img src=".github/assets/v1.0.0/screenshot2.png" width="49%" /> 
</p>

# About this repo
- This repo contains configuration files I daily drive on multiple machines, including Windows ones through [WSL](https://learn.microsoft.com/en-us/windows/wsl/). Its purpose is:
    - providing version control for my config files
    - serving as documentation and inspiration for customizing your system
- With this repo you get a [Flake](https://nixos.wiki/wiki/Flakes)-based [NixOS](https://nixos.org) configuration that includes...
  - two fully functional desktop sessions:
    - [Awesome](https://github.com/awesomeWM/awesome) (on Xorg)
    - [Hyprland](https://hyprland.org/) (on Wayland)
    - => See [Installation (Desktop)](#installation-desktop)
  - a nice [WSL](https://learn.microsoft.com/en-us/windows/wsl/) setup
    - => See [Installation (WSL)](#installation-wsl)
- See [Content overview](#content-overview) for explanations of files and directories in this repo.
- ⚠️ Basic knowledge of [NixOS](https://nixos.org/) usage, including [Nix flakes](https://nixos.wiki/wiki/Flakes), is needed for all of the provided installation guides.

# Content overview

### Directory structure
- `devices/` contains device-specific config
- `misc/` contains... miscellaneous things
- `modules/` contains Nix modules as well as config files for the software the module configures
  - e.g. `modules/hyprland` contains a `default.nix` to install [Hyprland](https://hyprland.org/) on [NixOS](https://nixos.org/), but also a `hyprland.conf` to configure [Hyprland](https://hyprland.org/)
- `packages/` contains Nix packages that I maintain locally as they do not have an official counterpart
- `wallpapers/` should be self-explanatory

### Noteworthy files

| File | Description |
|------|-------------|
| `devices/[DEVICE]/fastfetch/` | Device-specific [fastfetch](https://github.com/fastfetch-cli/fastfetch) configurations |
| `misc/update/` | Scripts to automatically update and clean up [NixOS](https://nixos.org) after a prompt every saturday |
| `misc/autostart.sh` | Shell script that [Awesome](https://github.com/awesomeWM/awesome) and [Hyprland](https://hyprland.org/) run on startup |
| `misc/notification.wav` | Notification sound |
| `modules/alacritty/alacritty.toml` | [Alacritty](https://github.com/alacritty/alacritty) configuration |
| `modules/awesome/` | [Awesome](https://github.com/awesomeWM/awesome) configuration including a custom theme based on [awesome-copycats](https://github.com/lcpz/awesome-copycats)' "rainbow" theme |
| `modules/copyq/copyq.conf` | [CopyQ](https://github.com/hluk/CopyQ) configuration with custom theme |
| `modules/eww/` | [Eww](https://github.com/elkowar/eww) configuration with custom widgets |
| `modules/firefox/firefox.css` | `userChrome.css` for [Firefox](https://www.mozilla.org/en-US/firefox/new/) |
| `modules/fish/init.fish` | `config.fish` for [Fish](https://github.com/fish-shell/fish-shell) |
| `modules/gitnuro/gitnuro.json` | [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme |
| `modules/hyprland/hyprland.conf` | [Hyprland](https://hyprland.org/) configuration |
| `modules/jetbrains/.ideavimrc` | Like `.vimrc`, but for [IntelliJ IDEA](https://github.com/JetBrains/intellij-community) using [IdeaVim](https://github.com/JetBrains/ideavim) |
| `modules/rofi/` | [Rofi](https://github.com/lbonn/rofi) (Wayland fork) themes |
| `modules/sddm-sugar-candy/sddm-sugar-candy.conf` | [sddm-sugar-candy](https://github.com/Kangie/sddm-sugar-candy) configuration |
| `modules/starship/starship.toml` | [Starship](https://github.com/starship/starship) configuration |
| `modules/swaylock-effects/swaylock-effects.sh` | Shell script to call [Swaylock-effects](https://github.com/jirutka/swaylock-effects) with custom options |
| `modules/swaync/` | [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) configuration with custom theme |
| `modules/vim/.vimrc` | [Vim](https://github.com/vim/vim) configuration |
| `modules/vscodium/vscodium.json` | `settings.json` for [VSCodium](https://github.com/VSCodium/vscodium) |
| `wallpapers/nixos/` | [NixOS](https://nixos.org) logo wallpapers in all kinds of color combinations |

# Installation (Desktop)

- The following guide explains the installation of [NixOS](https://nixos.org/) with my configuration on a desktop system.
- ⚠️ I try to make this config as modular and hardware independent as it makes sense for my time, but you might still have to change some things to make it work with your hardware.
- If you still want to try setting this up, here you go...

Download the "Minimal ISO image" of NixOS from [here](https://nixos.org/download/#nix-more), write it to a USB drive (e.g. with [USBImager](https://bztsrc.gitlab.io/usbimager/)) and boot it. If you don't have a wired internet connection, see how to set up wifi in the installer [here](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking).

Next, we will continue with some commands:
```shell
# you might want to change your keyboard layout, e.g.
sudo loadkeys de

cd /tmp
# download disko disk config
# you probably don't want to use my exact configuration,
# see https://github.com/nix-community/disko to build your own
curl -o disk-config.nix https://raw.githubusercontent.com/julius-boettger/dotfiles/main/devices/desktop/disk-config.nix
# check names of available disks
lsblk
# adjust disk config
vim disk-config.nix
# run disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disk-config.nix
# check if resulting mounts look plausible 
mount | grep /mnt

# prepare nixos config
sudo nixos-generate-config --no-filesystems --root /mnt
cd /mnt/etc/nixos
sudo mv /tmp/disk-config.nix .

# start editing the config, keep on reading to see what you should change
sudo vim configuration.nix
```

There should be a ton of commented-out code in this file that might be useful for you, feel free to comment it in.

Particularly important is that your configuration contains the following:

```sh
imports = [
  # import disko and disk config
  "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
  ./disk-config.nix
  # import generated hardware config
  ./hardware-configuration.nix
];

# set keyboard layout
console.keyMap = "de";

# make sure your favorite editor is available
environment.systemPackages = with pkgs; [
  vim
];
```

Save your changes and run `sudo nixos-install`.

Shutdown your system, remove the USB drive and boot your newly installed operating system.

Then run some more commands:

```sh
# make sure git is available, e.g. with
nix-shell -p git

# clone this repository to obtain my configuration
cd /etc
# clone current commit (although you don't know what you get)
git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git
# clone specific release (you know what you get, but v1.0.0 might not work anymore)
git clone --branch v2.0.0 --depth 1 --recurse-submodules https://github.com/julius-boettger/dotfiles.git

# copy over your disk and hardware config (!)
cp -f /etc/nixos/hardware-configuration.nix /etc/dotfiles/devices/desktop/
cp -f /etc/nixos/disk-config.nix /etc/dotfiles/devices/desktop/
```

> Paths like `devices/desktop/default.nix` are referencing the content of this repo, which should now be in `/etc/dotfiles/`, so the full path in this case would be `/etc/dotfiles/devices/desktop/default.nix`.

There are some files you now should take a look at and adjust them to your liking:
- `variables.nix` (should explain itself)
- `default.nix` and `hyprland.conf` in `devices/desktop/` contain some device- / hardware-specific configuration like setting the resolution, mounting a partition, ... You may pick and choose what seems useful to you, or just delete it.
- Of course you may also want to look at and change every other file ;)

```shell
# make sure the nix flake can see all your files
cd /etc/dotfiles
git add .

# rebuild the system
# after you've done this once, `flake-rebuild` should be available as a shorthand that serves the same purpose.
nixos-rebuild switch --flake /etc/dotfiles#desktop --impure

# set a password for your created user
passwd <USER>

# transfer ownership of the config to your created user to make editing it more comfortable
chown -R <USER>:root /etc/dotfiles
```

Next: `reboot` for good measure.

~~Set [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme: Run Gitnuro, open the settings and click the "Open file" button next to "Custom theme". Select `modules/gitnuro/gitnuro.json` and click on "Accept".~~ (My theme is currently broken)

To set a wallpaper for [SDDM](https://github.com/sddm/sddm) (the display manager) either put a `login.jpg` in `wallpapers/` or adjust the path to the wallpaper at the top of `modules/sddm-sugar-candy/sddm-sugar-candy.conf`.

By default, both the Awesome and the Hyprland session use a random wallpaper out of `wallpapers/nixos/` on every reload. But there's an easy way to set up your own wallpapers on Hyprland: Put just one (or multiple!)  in `wallpapers/misc/`. A random one will be selected on each reload if you have multiple. You can also configure corresponding accent colors for each wallpaper that will be used e.g. for the client border color. To do this, ajdust `modules/hyprland/wallpaper.py`. You will figure it out.

If you notice that the mouse cursor looks different when hovering over some apps, try setting it with `nwg-look` (Wayland) or `lxappearance` (Xorg).

And then you should be all set up!  Feel free to reach out if there's something missing, misleading or incorrect in this installation guide. (Also reach out if you know how to automate any step of this setup further!)

# Installation ([WSL](https://learn.microsoft.com/en-us/windows/wsl/))

> The following guide explains installation on a Windows system through [NixOS](https://nixos.org/) on [WSL](https://learn.microsoft.com/en-us/windows/wsl/).

First, make sure WSL is installed and up to date:
```
wsl --install --no-distribution
wsl --update
```
Also make sure to reboot your system to complete the setup (yes, that is necessary).

Then [setup a NixOS distribution](https://nixos.wiki/wiki/WSL), **but** be careful when executing a command containing a path like `.\NixOS\`, you probably want to change that to an absolute path where the installed files can reside permanently, like `C:\Users\[YOUR-USER]\Documents\WSL\NixOS\`.

Now enter your NixOS WSL system with `wsl -d NixOS`, or just with `wsl` if you ran `wsl --set-default NixOS` before.

Run `sudo nix-channel --update`. If you run into errors like `unable to download [...]: Couldn't resolve host name`: Make sure you are not connected to some regulated company network for the rest of this guide, then edit `/etc/resolv.conf` and check that the only uncommented lines in that file are to configure nameservers, e.g. to use google nameservers:
```
nameserver 8.8.4.4
nameserver 8.8.8.8
```
Then run `sudo nix-channel --update` again.

Now run some more commands to setup my config:
```shell
cd /etc
nix-shell -p git --run "sudo git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git"
```

You now should take a look at `variables.nix`, which should explain its content itself. Of course you may also want to look at and change every other file ;)

Then run some more commands:
```sh
# rebuild the system
# after you've done this once, `flake-rebuild` should be available as a shorthand that serves the same purpose.
nix-shell -p git --run "sudo nixos-rebuild switch --flake /etc/dotfiles#wsl"

# transfer ownership of the config to your created user to make editing it more comfortable
chown -R <USER>:root /etc/dotfiles
```

To see the effects, exit your current WSL session (e.g. with `exit`), force WSL to shutdown (to achieve a restart) with `wsl --shutdown` and then start a new session (e.g. with `wsl -d NixOS`).

You should be greeted by a nice little `fastfetch` now!

At this point it should also be fine to connect to a regulated company network again, reaching the internet should still be possible.

If using your companys VPN ever causes networking issues, use `vpn-start`/`vpn-stop` to start/stop [`wsl-vpnkit`](https://github.com/sakai135/wsl-vpnkit) (`vpn-status` is also available).