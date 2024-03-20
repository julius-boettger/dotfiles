# [NixOS](https://nixos.org/) configuration and other dotfiles

### Credit
- My [Awesome](https://awesomewm.org/) config is based on the "rainbow" theme of [awesome-copycats](https://github.com/lcpz/awesome-copycats)
- My [Rofi](https://github.com/lbonn/rofi) themes are based on the "rounded" theme of [rofi-themes-collection](https://github.com/newmanls/rofi-themes-collection)
- The wallpapers in `wallpapers/nixos/` as well as `wallpapers/login.png` are modified versions of `nix-wallpaper-nineish-dark-gray` of [nixos-artwork](https://github.com/NixOS/nixos-artwork)

# Screenshots / Showcase (version [v1.0.0](https://github.com/julius-boettger/dotfiles/releases/tag/v1.0.0))
https://github.com/julius-boettger/dotfiles/assets/85450899/4f33b2a8-80b3-47ff-8cc9-b1298d3d5de2
<p align="middle">
  <img src=".github/assets/screenshot1.png" width="49%" />
  <img src=".github/assets/screenshot2.png" width="49%" /> 
</p>

# About this repo
- This repo contains configuration files I daily drive on a private machine at home. Its purpose is:
    - providing version control for my config files
    - serving as documentation and inspiration for customizing your system
- With this repo you get two fully functional desktop sessions:
  - [Awesome](https://github.com/awesomeWM/awesome) + [Picom](https://github.com/jonaburg/picom) (on Xorg)
  - [Hyprland](https://hyprland.org/) (on Wayland)
- See [Content overview](#content-overview) for explanations of files and directories in this repo
- If (for some reason) you would like to replicate my exact system, see [Installation](#installation)

# Content overview
> Note: "Recommended directory" is the path to the directory where the described file (or directory) is usually located. This is either just `/etc/dotfiles/`, because this repository is assumed to be there, or another path, where a dotfile will be symlinked. See the end of [`nix/configuration.nix`](https://github.com/julius-boettger/dotfiles/blob/main/nix/configuration.nix) for the exact symlinks that are created.

| File or directory | Recommended directory | Description |
|-------------------|-----------------------|-------------|
| `nix/` | `/etc/dotfiles/` | All about [NixOS](https://nixos.org) |
| `nix/configuration.nix` | `/etc/dotfiles/` | [NixOS](https://nixos.org) configuration |
| `nix/update/` | `/etc/dotfiles/` | Scripts to automatically update and clean up [NixOS](https://nixos.org) after a prompt every saturday |
| `nix/pkgs/` | `/etc/dotfiles/` | Local Nix packages |
| `gitnuro.json` | `/etc/dotfiles/` | [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme |
| `autostart.sh` | `/etc/dotfiles/` | Script for autostarting background processes (called by Xorg window manager or Wayland compositor on startup) |
| `notification.wav` | `/etc/dotfiles/` | Notification sound |
| `wallpapers/nixos/` | `/etc/dotfiles/` | NixOS logo wallpapers in all kinds of color combinations |
| `awesome/` | `~/.config/` | [Awesome](https://github.com/awesomeWM/awesome) configuration including a custom theme based on [awesome-copycats](https://github.com/lcpz/awesome-copycats)' "rainbow" theme |
| `swaync/` | `~/.config/` | [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) configuration with custom theme |
| `eww/` | `~/.config/` | [Eww](https://github.com/elkowar/eww) configuration with custom widgets |
| `picom.conf` | `~/.config/` | [picom (jonaburg-fork)](https://github.com/jonaburg/picom) configuration |
| `starship.toml` | `~/.config/` | [Starship](https://github.com/starship/starship) configuration |
| `alacritty.toml` | `~/.config/alacritty/` | [Alacritty](https://github.com/alacritty/alacritty) configuration |
| `copyq.conf` | `~/.config/copyq/` | [CopyQ](https://github.com/hluk/CopyQ) configuration with custom theme |
| `hyprland/hyprland.conf` | `~/.config/hypr/` | [Hyprland](https://hyprland.org/) configuration |
| `fastfetch/` | `~/.config/fastfetch/` | [fastfetch](https://github.com/fastfetch-cli/fastfetch) configurations |
| `rofi/` | `~/.local/share/rofi/themes/` | [Rofi](https://github.com/lbonn/rofi) (Wayland fork) themes |
| `fish-init.fish` | `~/.config/fish/` | `config.fish` for [Fish](https://github.com/fish-shell/fish-shell) |
| `vscodium.json` | `~/.config/VSCodium/User/` | `settings.json` for [VSCodium](https://github.com/VSCodium/vscodium) |
| `firefox.css` | `~/.mozilla/firefox/[YOUR-PROFILE]/chrome/` | `userChrome.css` for [Firefox](https://www.mozilla.org/en-US/firefox/new/) |
| `sddm-sugar-candy.conf` | `/usr/share/sddm/themes/sugar-candy/` (somewhere in `/nix/store/` on NixOS) | [sddm-sugar-candy](https://github.com/Kangie/sddm-sugar-candy) configuration |
| `.ideavimrc` | `~/` | Like `.vimrc`, but for [IntelliJ IDEA](https://github.com/JetBrains/intellij-community) using [IdeaVim](https://github.com/JetBrains/ideavim) |

# Installation

- The following guide explains installation on a [NixOS](https://nixos.org/) system (which is my use case).
- ⚠️ Knowledge of basic [NixOS](https://nixos.org/) usage is needed. Try it out first before attempting to follow this guide.
- ⚠️ I try to make the config files in this repo modular and hardware independent, but you might still have to change some things to make it work with your hardware. The current configuration assumes:
    - a dual-monitor setup
    - a stationary/dektop system (you _could_ try it out on a portable system, but would probably miss things like a battery or wifi indicator)
- If you still want to try setting this up, here you go...

First install [NixOS](https://nixos.org/) and set it up far enough to have `git`, a network connection and a text editor available.

If you know your way around [Nix channels](https://nixos.wiki/wiki/Nix_channels), then do your thing, I had the best experience when `nix-channel --list` showed nothing and `sudo nix-channel --list` showed just one stable channel called `nixos` (if you don't have that add it with something like `sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixos`).

Place the content of this repository inside `/etc/dotfiles/`:
```shell
cd /etc

# clone current commit (recommended, although you don't know what you get that well)
git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git
# OR clone specific release (you know better what you get, but might not work anymore with newer versions of configured software)
git clone --branch v1.0.0 --depth 1 --recurse-submodules https://github.com/julius-boettger/dotfiles.git

chown -R $USER:root /etc/dotfiles # not necessary, but makes editing files more comfortable
chmod -R 755 /etc/dotfiles # should already be set like this
```

There are some files you now **NEED** to take a look at and adjust them to your liking, all in `/etc/dotfiles/`:
- `nix/variables.nix`
- Example files where you also need to delete the `.example` at the end of their file names (**!!!**):
  - `nix/secrets.nix.example`
  - `nix/extra-config.nix.example`
  - `hyprland/extra-config.conf.example`

If you search for `xrandr` in `awesome/rc.lua` you will find two commands which are for my specific dual-monitor setup. The idea is that one command configures both monitors and the other just the primary monitor, so that the secondary monitor is toggleable by pressing Super+P. If you want to use this functionality you will have to adjust the commands for your specific setup. ~~But you can also just leave them like that and don't press Super+P.~~

It's pretty much the same thing for my Hyprland config, but I extracted the device specific stuff into two variables called `second_monitor` and `second_monitor_config`, which I set in `/etc/dotfiles/hyprland/extra-config.conf`. The default config there shows what works for my setup.

Then rebuild your system with `sudo nixos-rebuild switch -I nixos-config=/etc/dotfiles/nix/configuration.nix`. You only need to specify the `nixos-config` path like this when rebuilding for the first time, after that it will be set by the configuration itself and just `sudo nixos-rebuild switch` will be enough.

Prepare Firefox customization: Run Firefox and set it up to your liking (but don't choose a theme, you will load my own one later). Then enter `about:profiles` in the Firefox URL bar and identify the profile you have set up. Copy the name of the profile directory in `~/.mozilla/firefox/` that is displayed under "Root Directory" (usually something like `h5hep79f.dev-edition-default`). Use it as the value of `firefox.profile` in `/etc/dotfiles/nix/secrets.nix` instead of `test` and rebuild your system, e.g. with `sudo nixos-rebuild switch`.

Next: `reboot` for good measure.

Set your `git` credentials using [`git-credential-manager`](https://github.com/git-ecosystem/git-credential-manager): E.g. to authenticate with Github run `git-credential-manager github login`.

Set [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme: Run Gitnuro, open the settings and click the "Open file" button next to "Custom theme". Select `/etc/dotfiles/gitnuro.json` and click on "Accept".

If you notice that the mouse cursor looks different when hovering over some apps, try setting it with `nwg-look` (Wayland) or `lxappearance` (Xorg).

By default, both the Awesome and the Hyprland session use a random wallpaper out of `/etc/dotfiles/wallpapers/nixos/` on every reload. But there's an easy way to set up your own wallpapers on Hyprland: Put just one (or multiple!)  in `/etc/dotfiles/wallpapers/other/`. A random one will be selected on each reload if you have multiple. You can also configure corresponding accent colors for each wallpaper that will be used e.g. for the client border color. To do this, ajdust `/etc/dotfiles/hyprland/wallpaper.py`. You will figure it out.

### And then you should be all set up!

Feel free to reach out if there's something missing, misleading or incorrect in this installation guide.

> Also reach out if you know how to automate any step of this setup further!