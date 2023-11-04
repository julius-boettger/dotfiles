# This is a development branch for adding Wayland support! You should probably stick to `main` for now.

# [NixOS](https://nixos.org/) configuration and other dotfiles
> These dotfiles are what I daily drive at home, so you can be sure that they (kind of) work

### Credit
- My [awesome](https://awesomewm.org/) config is based on the "rainbow" theme of [awesome-copycats](https://github.com/lcpz/awesome-copycats), which I then modified to fit my taste and needs
- The wallpapers in `wallpapers/nixos/` are modified versions of `nix-wallpaper-nineish-dark-gray` of [nixos-artwork](https://github.com/NixOS/nixos-artwork)

# Screenshots / Showcase (version [v1.0.0](https://github.com/julius-boettger/dotfiles/releases/tag/v1.0.0))
https://github.com/julius-boettger/dotfiles/assets/85450899/4f33b2a8-80b3-47ff-8cc9-b1298d3d5de2
<p align="middle">
  <img src=".github/assets/screenshot1.png" width="49%" />
  <img src=".github/assets/screenshot2.png" width="49%" /> 
</p>

# Content overview
> Note: "Recommended directory" is the path to the directory where the described file (or directory) is usually located. This is either just `/etc/dotfiles/`, because this repository is assumed to be there, or another path, where a dotfile will be symlinked. See [`nix/pkgs/symlink-dotfiles.nix`](https://github.com/julius-boettger/dotfiles/blob/main/nix/pkgs/symlink-dotfiles.nix) for the script that should create those symlinks.

| File or directory | Recommended directory | Description |
|-------------------|-----------------------|-------------|
| `nix/` | `/etc/dotfiles/` | All about [NixOS](https://nixos.org) |
| `nix/configuration.nix` | `/etc/dotfiles/` | [NixOS](https://nixos.org) configuration |
| `nix/update/` | `/etc/dotfiles/` | Scripts to automatically update and clean up [NixOS](https://nixos.org) after a prompt every saturday |
| `nix/pkgs/` | `/etc/dotfiles/` | Local Nix packages |
| `gitnuro.json` | `/etc/dotfiles/` | Custom theme for [Gitnuro](https://github.com/JetpackDuba/Gitnuro) |
| `autostart.sh` | `/etc/dotfiles/` | Script for autostarting background processes (called by Xorg window manager or Wayland compositor on startup) |
| `wallpapers/nixos/` | `/etc/dotfiles/` | NixOS logo wallpapers in all kinds of color combinations |
| `awesome/` | `~/.config/` | Configuration for [Awesome](https://github.com/awesomeWM/awesome) including a theme based on [awesome-copycats](https://github.com/lcpz/awesome-copycats)' "rainbow" theme |
| `picom.conf` | `~/.config/` | Configuration for [picom (jonaburg-fork)](https://github.com/jonaburg/picom) |
| `ulauncher/` | `~/.config/` | Configuration for [Ulauncher](https://github.com/Ulauncher/Ulauncher/) including a custom color theme |
| `hyprland/hyprland.conf` | `~/.config/hypr/` | [Hyprland](https://hyprland.org/) configuration |
| `neofetch.conf` | `~/.config/neofetch/` | `config.conf` for configuring [neofetch](https://github.com/dylanaraps/neofetch) |
| `firefox.css` | `~/.mozilla/firefox/[YOUR-PROFILE]/chrome/` | `userChrome.css` for theming [Firefox](https://www.mozilla.org/en-US/firefox/new/) |
| `sddm-sugar-candy/` | `/usr/share/sddm/themes/` (somewhere in `/nix/store/` on NixOS) | Configuration for [sddm-sugar-candy](https://github.com/Kangie/sddm-sugar-candy) |
| `.ideavimrc` | `~/` | Like `.vimrc`, but for [IntelliJ IDEA](https://github.com/JetBrains/intellij-community) using [IdeaVim](https://github.com/JetBrains/ideavim) |

# Installation & usage

- Most of these dotfiles can be used independently of the others, like `picom.conf` for configuring [picom](https://github.com/jonaburg/picom). You are free to use just parts the parts you like as they suit you.
    - See [Content overview](#content-overview) for explanations of files and directories.
- The following guide explains installation on a [NixOS](https://nixos.org/) system (which is my use case).
- ⚠️ Knowledge of basic [NixOS](https://nixos.org/) usage is needed. Try it out first before attempting to follow this guide.
- ⚠️ This guide assumes that you have either backed up your config files or don't care about them, as it may override or delete them (specifically the `symlink-dotfiles` command, see what it does [here](https://github.com/julius-boettger/dotfiles/blob/main/nix/pkgs/symlink-dotfiles.nix)).

First install [NixOS](https://nixos.org/) and set it up far enough to have `git`, a network connection and a text editor available.

Then place the content of this repository inside `/etc/dotfiles/`:
```shell
cd /etc
sudo git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git
chown -R $USER:root /etc/dotfiles # not necessary, but makes editing files more comfortable
chmod -R 755 /etc/dotfiles # should already be set like this
```

Take a look at `/etc/dotfiles/nix/variables.nix` and adjust it to your liking.

Create `/etc/dotfiles/nix/secrets.nix` and adjust its content to your liking. Template:
```nix
{
    # networking host name of this device
    networking.hostName = "nixos";
    # global git config
    git.name = "username";
    git.email = "example@provider.com";
    # server port for barrier (can stay like this)
    barrier.port = 20000;
    # firefox profile to customize (can stay like this for now, will be set later)
    firefox.profile = "test";
}
```

Also make sure to either create `/etc/dotfiles/nix/extra-config.nix` (and put some expression in it) or remove the line containing `./extra-config.nix` in `/etc/dotfiles/nix/configuration.nix`. I use `extra-config.nix` for device specific configuration that I don't want to push to this repo. You could also do that or just modify `configuration.nix`, as you will probably not be pushing to this repo.

I use a similar `extra-config` file for Hyprland, which you will need to create. You can put your device specific configuration (e.g. [monitor config](https://wiki.hyprland.org/Configuring/Monitors/)) in there or simply keep the file empty, but make sure to create it: `touch /etc/dotfiles/hyprland/extra-config.conf`

If you search for `xrandr` in `awesome/rc.lua` you will find two commands which are for my specific dual-monitor setup. The idea is that one command configures both monitors and the other just the primary monitor, so that the secondary monitor is toggleable by pressing Super+P. If you want to use this functionality you will have to adjust the commands for your specific setup. ~~But you can also just leave them like that and don't press Super+P.~~

It's pretty much the same thing for my Hyprland config, but I extracted the device specific stuff into two variables called `second_monitor` and `second_monitor_config`, which I set in `/etc/dotfiles/hyprland/extra-config.conf`. If you really want to use it, you will figure it out.

Then rebuild your system with `sudo nixos-rebuild switch -I nixos-config=/etc/dotfiles/nix/configuration.nix`. You only need to specify the `nixos-config` path like this when rebuilding for the first time, after that it will be set by the configuration itself and just `sudo nixos-rebuild switch` will be enough.

Prepare Firefox customization: Run Firefox and set it up to your liking (but don't choose a theme, you will load my own one later). Then enter `about:profiles` in the Firefox URL bar and identify the profile you have set up. Copy the name of the profile directory in `~/.mozilla/firefox/` that is displayed under "Root Directory" (usually something like `h5hep79f.dev-edition-default`). Use it as the value of `firefox.profile` in `/etc/dotfiles/nix/secrets.nix` instead of `"test"` and rebuild your system, e.g. with `sudo nixos-rebuild switch`.

Now run `symlink-dotfiles` to create symlinks to put dotfiles in their respective locations. This runs a script that I've written, see `nix/pkgs/symlink-dotfiles.nix` for more information. If this outputs something like "cannot overwrite directory" you might need to manually remove that directory and try again.

Next: `reboot` for good measure.

Set your `git` credentials using [`git-credential-manager`](https://github.com/git-ecosystem/git-credential-manager): E.g. to authenticate with Github run `git-credential-manager github login`.

Set [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme: Run Gitnuro, open the settings and click the "Open file" button next to "Custom theme". Select `/etc/dotfiles/gitnuro.json` and click on "Accept".

If you notice that the mouse cursor looks different when hovering over some apps, try setting it with `nwg-look` (Wayland) or `lxappearance` (Xorg).

Finally install a [Ulauncher](https://github.com/Ulauncher/Ulauncher/) extension for emojis: Run Ulauncher with `Super+R` and click on the little gear to access the settings. Then go to the tab EXTENSIONS, click on "Add extension" and entering the following URL: 
```
https://github.com/Ulauncher/ulauncher-emoji
```
You might need to click on "Reload the list" or restart Ulauncher (`pkill ulauncher && ulauncher &`) for the changes to take effect.

### And then you should be all set up!

Feel free to reach out if there's something missing, misleading or incorrect in this installation guide.

> Also reach out if you know how to automate any step of this setup further!