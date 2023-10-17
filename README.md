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
> Note: "Recommended directory" is the path to the directory where the described file (or directory) is usually located. This is either just `/etc/nixos/`, because this repository is assumed to be there, or another path, where a dotfile will be symlinked. See [`nix/pkgs/symlink-dotfiles.nix`](https://github.com/julius-boettger/dotfiles/blob/main/nix/pkgs/symlink-dotfiles.nix) for the script that should create those symlinks.

| File or directory | Recommended directory | Description |
|-------------------|-----------------------|-------------|
| `nix/` | `/etc/nixos/` | All about [NixOS](https://nixos.org) |
| `nix/configuration.nix` | `/etc/nixos/` | [NixOS](https://nixos.org) configuration |
| `nix/update/` | `/etc/nixos/` | Scripts to automatically update and clean up [NixOS](https://nixos.org) after a prompt every saturday |
| `nix/pkgs/` | `/etc/nixos/` | Local Nix packages |
| `gitnuro.json` | `/etc/nixos/` | Custom theme for [Gitnuro](https://github.com/JetpackDuba/Gitnuro) |
| `awesome/` | `~/.config/` | Configuration for [Awesome](https://github.com/awesomeWM/awesome) including a theme based on [awesome-copycats](https://github.com/lcpz/awesome-copycats)' "rainbow" theme |
| `picom.conf` | `~/.config/` | Configuration for [picom (jonaburg-fork)](https://github.com/jonaburg/picom) |
| `ulauncher/` | `~/.config/` | Configuration for [Ulauncher](https://github.com/Ulauncher/Ulauncher/) including a custom color theme |
| `neofetch.conf` | `~/.config/neofetch/` | `config.conf` for configuring [neofetch](https://github.com/dylanaraps/neofetch) |
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

Then place the content of this repository inside `/etc/nixos/`. This is necessary as many paths in the configuration rely on it. A possible way to do this (assuming you have the necessary permissions) is:
```shell
cd /tmp
git clone --recurse-submodules https://github.com/julius-boettger/dotfiles.git
cp -rf dotfiles/* /etc/nixos
```

Create `/etc/nixos/nix/secrets.nix` and adjust its content to your liking. Template:
```nix
{
    # global git config
    git.name = "username";
    git.email = "example@provider.com";
    # server port for barrier (can stay like this)
    barrier.port = 20000;
    # modprobe config for focusrite usb audio interfaces (can stay like this)
    modprobe.focusrite = "";
    # firefox profile to customize (can stay like this for now, will be set later)
    firefox.profile = "test";
}
```

Make sure to carefully inspect `nix/configuration.nix` and edit it as needed before rebuilding, as you may not want e.g. NVIDIA drivers or the username `julius`.

Other configuration files may also contain hardware specific code, like `xrandr` commands in `awesome/rc.lua`, which are for my specific monitor setup. These shouldn't break anything right away though (famous last words), so you may fix them as you go.

If you are using a USB audio interface from Focusrite: Run `dmesg | grep Focusrite`. If this outputs something like "device disabled, put ... in modprobe.d to enable", then copy the given modprobe config (something like `options snd_usb_audio vid=0x0000 pid=0x0000 device_setup=0`) and use it as the `modprobe.focusrite` string in `/etc/nixos/nix/secrets.nix`.

Then rebuild your system with `sudo nixos-rebuild switch -I nixos-config=/etc/nixos/nix/configuration.nix`. You only need to specify the `nixos-config` path like this when rebuilding for the first time, after that it will be set by the configuration itself and just `sudo nixos-rebuild switch` will be enough.

Prepare Firefox customization: Run Firefox and set it up to your liking (but don't choose a theme, you will load my own one later). Then enter `about:profiles` in the Firefox URL bar and identify the profile you have set up. Copy the name of the profile directory in `~/.mozilla/firefox/` that is displayed under "Root Directory" (usually something like `h5hep79f.dev-edition-default`). Use it as the value of `firefox.profile` in `/etc/nixos/nix/secrets.nix` instead of `"test"` and rebuild your system, e.g. with `sudo nixos-rebuild switch`.

Prepare [AutoKey](https://github.com/autokey/autokey) phrase directory: Run AutoKey (`autokey-gtk`) and create a new folder `~/.config/autokey/phrases`. My AutoKey phrases will be linked to that directory in the next step, but it needs to be created like this first.

Now run `symlink-dotfiles` to create symlinks to put dotfiles in their respective locations. This runs a script that I've written, see `nix/pkgs/symlink-dotfiles.nix` for more information. If this outputs something like "cannot overwrite directory" you might need to manually remove that directory and try again.

Next: `reboot` for good measure.

Set your `git` credentials using [`git-credential-manager`](https://github.com/git-ecosystem/git-credential-manager): E.g. to authenticate with Github run `git-credential-manager github login`.

Set [Gitnuro](https://github.com/JetpackDuba/Gitnuro) theme: Run Gitnuro, open the settings and click the "Open file" button next to "Custom theme". Select `/etc/nixos/gitnuro.json` and click on "Accept".

Finally install a [Ulauncher](https://github.com/Ulauncher/Ulauncher/) extension for emojis: Run Ulauncher with `Super+R` and click on the little gear to access the settings. Then go to the tab EXTENSIONS, click on "Add extension" and entering the following URL: 
```
https://github.com/Ulauncher/ulauncher-emoji
```
You might need to click on "Reload the list" or restart Ulauncher (`pkill ulauncher && ulauncher &`) for the changes to take effect.

### And then you should be all set up!

Feel free to reach out if there's something missing, misleading or incorrect in this installation guide.

> Also reach out if you know how to automate any step of this setup further!