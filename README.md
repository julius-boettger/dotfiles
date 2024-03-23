# [NixOS](https://nixos.org/) configuration and other dotfiles

### Credit
- My [Awesome](https://awesomewm.org/) config is based on the "rainbow" theme of [awesome-copycats](https://github.com/lcpz/awesome-copycats)
- My [Rofi](https://github.com/lbonn/rofi) themes are based on the "rounded" theme of [rofi-themes-collection](https://github.com/newmanls/rofi-themes-collection)
- The wallpapers in `wallpapers/nixos/` as well as `wallpapers/login.png` are modified versions of `nix-wallpaper-nineish-dark-gray` of [nixos-artwork](https://github.com/NixOS/nixos-artwork)

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
- This repo contains configuration files I daily drive on multiple machines, including a Windows one through [WSL](https://learn.microsoft.com/en-us/windows/wsl/). Its purpose is:
    - providing version control for my config files
    - serving as documentation and inspiration for customizing your system
- With this repo you get a [Flake](https://nixos.wiki/wiki/Flakes)-based [NixOS](https://nixos.org) configuration that includes...
  - two fully functional desktop sessions:
    - [Awesome](https://github.com/awesomeWM/awesome) + [Picom](https://github.com/jonaburg/picom) (on Xorg)
    - [Hyprland](https://hyprland.org/) (on Wayland)
    - => See [Installation (Desktop)](#installation-desktop)
  - a nice [WSL](https://learn.microsoft.com/en-us/windows/wsl/) setup
    - => See [Installation (WSL)](#installation-wsl)
- See [Content overview](#content-overview) for explanations of files and directories in this repo.
- ⚠️ Basic knowledge of [NixOS](https://nixos.org/) usage, including [Nix flakes](https://nixos.wiki/wiki/Flakes), is needed for all of the provided installation guides.

# Content overview
> Note: "Expected directory" is the path to the directory where the described file (or directory) is usually located. This could just be `/etc/dotfiles/`, because this repository is assumed to be there, or another path, where a dotfile will be symlinked. Search for `mkOutOfStoreSymlink` in `nix/` for the exact symlinks that are created.

| File or directory | Expected directory | Description |
|-------------------|--------------------|-------------|
| `nix/` | `/etc/dotfiles/` | All about [NixOS](https://nixos.org) |
| `nix/update/` | `/etc/dotfiles/` | Scripts to automatically update and clean up [NixOS](https://nixos.org) after a prompt every saturday |
| `nix/pkgs/` | `/etc/dotfiles/` | Local Nix packages |
| `wallpapers/nixos/` | `/etc/dotfiles/` | NixOS logo wallpapers in all kinds of color combinations |
| `other/autostart.sh` | `/etc/dotfiles/` | Script for autostarting background processes (called by WM/compositor on startup) |
| `other/notification.wav` | `/etc/dotfiles/` | Notification sound |
| `other/starship.toml` | `/etc/dotfiles/` | [Starship](https://github.com/starship/starship) configuration |
| `other/.ideavimrc` | `~/` | Like `.vimrc`, but for [IntelliJ IDEA](https://github.com/JetBrains/intellij-community) using [IdeaVim](https://github.com/JetBrains/ideavim) |
| `awesome/` | `~/.config/` | [Awesome](https://github.com/awesomeWM/awesome) configuration including a custom theme based on [awesome-copycats](https://github.com/lcpz/awesome-copycats)' "rainbow" theme |
| `swaync/` | `~/.config/` | [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) configuration with custom theme |
| `eww/` | `~/.config/` | [Eww](https://github.com/elkowar/eww) configuration with custom widgets |
| `other/picom.conf` | `~/.config/` | [picom (jonaburg-fork)](https://github.com/jonaburg/picom) configuration |
| `hyprland/` | `~/.config/hypr/` | [Hyprland](https://hyprland.org/) configuration |
| `other/init.fish` | `~/.config/fish/` | `config.fish` for [Fish](https://github.com/fish-shell/fish-shell) |
| `other/copyq.conf` | `~/.config/copyq/` | [CopyQ](https://github.com/hluk/CopyQ) configuration with custom theme |
| `other/alacritty.toml` | `~/.config/alacritty/` | [Alacritty](https://github.com/alacritty/alacritty) configuration |
| `fastfetch/` | `~/.config/fastfetch/` | [fastfetch](https://github.com/fastfetch-cli/fastfetch) configurations |
| `other/vscodium.json` | `~/.config/VSCodium/User/` | `settings.json` for [VSCodium](https://github.com/VSCodium/vscodium) |
| `rofi/` | `~/.local/share/rofi/themes/` | [Rofi](https://github.com/lbonn/rofi) (Wayland fork) themes |
| `other/firefox.css` | `~/.mozilla/firefox/[YOUR-PROFILE]/chrome/` | `userChrome.css` for [Firefox](https://www.mozilla.org/en-US/firefox/new/) |
| `other/sddm-sugar-candy.conf` | `/usr/share/sddm/themes/sugar-candy/` (somewhere in `/nix/store/` on NixOS) | [sddm-sugar-candy](https://github.com/Kangie/sddm-sugar-candy) configuration |
| `other/gitnuro.json` | - | [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme |

# Installation (Desktop)

- The following guide explains installation on a [NixOS](https://nixos.org/) desktop system.
- ⚠️ I try to make the config files in this repo modular and hardware independent, but you might still have to change some things to make it work with your hardware. The current configuration assumes:
    - a dual-monitor setup
    - a stationary/dektop system (you _could_ try it out on a portable system, but would probably miss things like a battery or wifi indicator)
- If you still want to try setting this up, here you go...

First install [NixOS](https://nixos.org/) and set it up far enough to have `git`, a network connection and a text editor available.

Place the content of this repository inside `/etc/dotfiles/`:
```shell
cd /etc

# clone specific release (you know what you get, but v1.0.0 might not work anymore)
git clone --branch v2.0.0 --depth 1 --recurse-submodules https://github.com/julius-boettger/dotfiles.git
# clone current commit (although you don't know what you get)
git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git

chown -R $USER:root /etc/dotfiles # not necessary, but makes editing files more comfortable
chmod -R 755 /etc/dotfiles # should already be set like this

# copy over your hardware-configuration.nix (!)
cp -f /etc/nixos/hardware-configuration.nix /etc/dotfiles/nix/hosts/nixos/
```

If you search for `xrandr` in `awesome/rc.lua` you will find two commands which are for my specific dual-monitor setup. The idea is that one command configures both monitors and the other just the primary monitor, so that the secondary monitor is toggleable by pressing Super+P. If you want to use this functionality you will have to adjust the commands for your specific setup. ~~But you can also just leave them like that and don't press Super+P.~~

It's pretty much the same thing for my Hyprland config, but I extracted the device specific stuff into two variables called `second_monitor` and `second_monitor_config`, which I set in `/etc/dotfiles/hyprland/extra-config.conf`. The default config there shows what works for my setup.

There are some files you now **NEED** to take a look at and adjust them to your liking, all in `/etc/dotfiles/`...

- Example files where also you need to delete the `.example` at the end of their file names (**!!!**):
  - `hyprland/extra-config.conf.example` contains device-specific Hyprland configuration like the afore-mentioned monitor setup.
- Files in `nix/`:
  - `secrets.nix` and `variables.nix` (should explain themselves)
    - don't worry about `firefoxProfile`, we will set it later.
  - `hosts/nixos/default.nix` contains some device-specific configuration like mounting a partition. You may pick and choose what seems useful to you, or just delete it.
- Of course you may also want to look at and change every other file ;)

Then rebuild your system with `sudo nixos-rebuild switch --flake /etc/dotfiles/nix#desktop`. After you've done this once, `flake-rebuild` should be available as a shorthand that serves the same purpose.

**Apply Firefox customization**: Run Firefox and set it up to your liking (but don't choose a theme or a `userChrome.css`, you will load mine later). Then enter `about:profiles` in the Firefox URL bar and identify the profile you have set up. Copy the name of the profile directory in `~/.mozilla/firefox/` that is displayed under "Root Directory" (usually something like `h5hep79f.dev-edition-default`). Use it as the value of `firefoxProfile` in `/etc/dotfiles/nix/variables.nix` after the line `desktop = mkNixosConfig {` and rebuild your system, e.g. with `flake-rebuild`.

Next: `reboot` for good measure.

Set your `git` credentials using [`git-credential-manager`](https://github.com/git-ecosystem/git-credential-manager): E.g. to authenticate with Github run `git-credential-manager github login`.

Set [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme: Run Gitnuro, open the settings and click the "Open file" button next to "Custom theme". Select `/etc/dotfiles/other/gitnuro.json` and click on "Accept".

To set a wallpaper for [SDDM](https://github.com/sddm/sddm) (the login manager) either put a `login.jpg` in `/etc/dotfiles/wallpapers/` or adjust the path to the wallpaper at the top of `/etc/dotfiles/other/sddm-sugar-candy.conf`.

By default, both the Awesome and the Hyprland session use a random wallpaper out of `/etc/dotfiles/wallpapers/nixos/` on every reload. But there's an easy way to set up your own wallpapers on Hyprland: Put just one (or multiple!)  in `/etc/dotfiles/wallpapers/other/`. A random one will be selected on each reload if you have multiple. You can also configure corresponding accent colors for each wallpaper that will be used e.g. for the client border color. To do this, ajdust `/etc/dotfiles/hyprland/wallpaper.py`. You will figure it out.

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

Run `sudo nix-channel --update`. If you run into errors like `unable to download [...]: Couldn't resolve host name`: Make sure you are not connected to some regulated company network for the rest of this guide, then run `sudo nano /etc/resolv.conf` and check that the following lines are the only uncommented ones in that file:
```
nameserver 8.8.4.4
nameserver 8.8.8.8
```

Now run some more commands:

```shell
# do this again if it failed before
sudo nix-channel --update
# rebuild system with updated channel
sudo nixos-rebuild switch
### start setting up my config
cd /etc
nix-shell -p git --run "sudo git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git"
# make editing files more comfortable (don't require sudo)
sudo chown -R $USER:root /etc/dotfiles
```

You now should take a look at two files and adjust them to your liking, both in `/etc/dotfiles/nix/`: `secrets.nix` and `variables.nix`. They should explain themselves what they are for. Of course you may also want to look at and change every other file ;)

Then rebuild your system with
```sh
nix-shell -p git --run "sudo nixos-rebuild switch --flake /etc/dotfiles/nix#wsl"
```

To see the effects, exit your current WSL session (e.g. with `exit`), force WSL to shutdown (to achieve a restart) with `wsl --shutdown` and then start a new session (e.g. with `wsl -d NixOS`).

You should be greeted by a nice little `fastfetch` now! `flake-rebuild wsl` should also be available as a shorthand that serves the same purpose as the long rebuild command above.

At this point it should also be fine to connect to a regulated company network again, reaching the internet should still be possible.

Finally, you may want to set your `git` credentials using [`git-credential-manager`](https://github.com/git-ecosystem/git-credential-manager): E.g. to authenticate with Github run `git-credential-manager github login`.