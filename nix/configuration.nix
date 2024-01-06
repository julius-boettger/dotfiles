{ config, pkgs, ... }:

# import config variables that are shared by all of my devices
let variables = import ./variables.nix pkgs.callPackage;
in {
  # import other nix files
  imports = [
    # results of automatic hardware scan
    /etc/nixos/hardware-configuration.nix
    # home-manager
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-${variables.version}.tar.gz"}/nixos"
    # device specific config
    ./extra-config.nix
  ];

  # set path to configuration.nix
  nix.nixPath = [
    "nixos-config=/etc/dotfiles/nix/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # self-explaining one-liners
  console.keyMap = "de";
  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = variables.version;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # drivers for aio liquid coolers
  boot.extraModulePackages = with config.boot.kernelPackages; [ liquidtux ];
  boot.kernelModules = [ "liquidtux" ];

  networking = {
    hostName = variables.secrets.networking.hostName;
    networkmanager.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ variables.secrets.barrier.port ];
    allowedUDPPorts = [];
  };

  boot.loader = {
    timeout = 1;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 20; # number of generations to show
    };
  };

  i18n.defaultLocale  = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT    = "de_DE.UTF-8";
    LC_TELEPHONE      = "de_DE.UTF-8";
    LC_MONETARY       = "de_DE.UTF-8";
    LC_NUMERIC        = "de_DE.UTF-8";
    LC_ADDRESS        = "de_DE.UTF-8";
    LC_PAPER          = "de_DE.UTF-8";
    LC_NAME           = "de_DE.UTF-8";
    LC_TIME           = "de_DE.UTF-8";
  };

  # sound with pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = "true"; # "enables dbus experimental interfaces"
      FastConnectable = "true"; # connect faster but draw more power
      Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source"; # idk, from oaj
    };
  };

  ### user account and groups
  # create new group with username
  users.groups."${variables.username}" = {};
  # create user
  users.users."${variables.username}" = {
    isNormalUser = true;
    description = variables.displayname;
    extraGroups = [ # add user to groups (if they exist)
      variables.username
      "users"
      "wheel"
      "networkmanager"
    ];
  };

  ##########################################
  ##########################################
  ################ PACKAGES ################
  ##########################################
  ##########################################

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    # use packages from the unstable channel by prefixing them
    # with "unstable.", like "pkgs.unstable.onedrive"
    unstable = import (fetchTarball "https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz") {
      config = config.nixpkgs.config;
    };
    # use packages from the NUR by prefixing them with with
    # "nur.", like "pkgs.nur.repos.utybo.git-credential-manager"
    # NUR = nix user repository, like AUR but for nix
    nur = import (fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # fonts to install
  fonts.packages = with pkgs; [
    noto-fonts # ~200 standard modern fonts for all kinds of languages
    noto-fonts-cjk-sans # for asian characters
    aileron # modern text with 16 variations
    # install only specific nerd fonts
    (nerdfonts.override { fonts = [
      "Terminus"   # very square
      "FiraCode"   # good for code
      "RobotoMono" # good for code
    ]; } )
  ];

  # packages to install
  environment.systemPackages = with pkgs; [
    ### gui
    obs-studio
    firefox-devedition
    unstable.obsidian
    libreoffice
    discord
    bitwarden
    gimp-with-plugins
    jetbrains.idea-ultimate
    spotify
    pdfstudio2023
    bottles # run windows software easily
    pitivi # video editor
    tenacity # audio recorder and editor
    piper # configure gaming mice graphically with ratbagd
    protonup-qt # easy ge-proton setup for steam
    unigine-valley # gpu stress test and benchmark
    octaveFull # matlab alternative
    ghdl # vhdl simulator
    gtkwave # inspect waveforms created by ghdl
    digital # digital circuit simulator
    variables.pkgs.gitnuro # newer version compared to nixpkgs
    ventoy # create bootable usb sticks
    unstable.stacer # system monitor
    psensor # gui for (lm_)sensors to display system temperatures
    nvidia-system-monitor-qt # monitor nvidia gpu stuff
    darktable # photo editor and raw developer
    inkscape-with-extensions # vector graphic editor
    veracrypt # disk encryption
    freefilesync # file backup
    alsa-scarlett-gui # control center for focusrite usb audio interface
    unstable.git-credential-manager # gui authentication for git
    vlc # video player
    sioyek # pdf reader, also available as programs.sioyek in hm
    baobab # disk usage analyzer
    fluent-gtk-theme # gtk theme
    # sddm theme + dependency
    variables.pkgs.sddm-sugar-candy
    libsForQt5.qt5.qtgraphicaleffects
    # codium with extensions
    (vscode-with-extensions.override {
      vscode = unstable.vscodium;
      vscodeExtensions = with vscode-extensions; [
        # for syntax highlighting / language support
        bbenoist.nix
        ms-python.python 
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        coolbear.systemd-unit-file
        ms-azuretools.vscode-docker
        matthewpi.caddyfile-support
        # other stuff
        vscodevim.vim # vim :)
        ritwickdey.liveserver # quick webserver for testing
        esbenp.prettier-vscode # code formatter
        naumovs.color-highlight # highlight color codes with their color
        ms-python.vscode-pylance # more python
        pkief.material-icon-theme # file icon theme
        christian-kohler.path-intellisense # auto complete paths
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # solve leetcode problems
        { name = "vscode-leetcode";
          publisher = "LeetCode";
          version = "0.18.1";
          sha256 = "Ym9Gi9nL0b5dJq0yXbX2NvSW89jIr3UFBAjfGT9BExM="; }
        # monokai theme
        { name = "theme-monokai-pro-vscode";
          publisher = "monokai";
          version = "1.2.1";
          sha256 = "tRMuAqI6zqjvOCoESbJfD4fjgnA93pQ06ppvPDuwceQ="; }
        # view diff between two files
        { name = "partial-diff";
          publisher = "ryu1kn";
          version = "1.4.3";
          sha256 = "0Oiw9f+LLGkUrs2fO8vs7ITSR5TT+5T0yU81ouyedHQ="; }
        # vhdl syntax highlighting
        { name = "VerilogHDL";
          publisher = "mshr-h";
          version = "1.13.0";
          sha256 = "axmXLwVmMCmf7Vov0MbSaqM921uKUDeggxhCNoc6eYA="; }
        # rasi syntax highlighting
        { name = "rasi";
          publisher = "dlasagno";
          version = "1.0.0";
          sha256 = "s60alej3cNAbSJxsRlIRE2Qha6oAsmcOBbWoqp+w6fk="; }
        # yuck syntax highlighting
        { name = "yuck";
          publisher = "eww-yuck";
          version = "0.0.3";
          sha256 = "DITgLedaO0Ifrttu+ZXkiaVA7Ua5RXc4jXQHPYLqrcM="; }
      ];
    })
    # gtk icon theme
    ((papirus-icon-theme.override { /*folder-*/color = "black"; })
      # replace default firefox icons with firefox developer edition icons
      .overrideAttrs (attrs: { postInstall = (attrs.postInstall or "") + ''
        ln -sf $out/share/icons/Papirus/16x16/apps/firefox-developer-icon.svg $out/share/icons/Papirus/16x16/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/22x22/apps/firefox-developer-icon.svg $out/share/icons/Papirus/22x22/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/24x24/apps/firefox-developer-icon.svg $out/share/icons/Papirus/24x24/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/32x32/apps/firefox-developer-icon.svg $out/share/icons/Papirus/32x32/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/48x48/apps/firefox-developer-icon.svg $out/share/icons/Papirus/48x48/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/64x64/apps/firefox-developer-icon.svg $out/share/icons/Papirus/64x64/apps/firefox.svg
    ''; }))

    ### cli
    jq
    git
    vim
    bash
    fastfetch
    variables.pkgs.symlink-dotfiles
    playerctl # pause media with mpris
    liquidctl # liquid cooler control
    mprime # cpu stress test
    lm_sensors # system temperature sensor info
    dunst # for better notify-send with dunstify
    gphoto2fs # mount camera
    cbonsai # ascii art bonsai
    asciiquarium # ascii art aquarium
    starship # shell prompt, install as program and package to set PATH
    fortune # random quote
    lolcat # make things rainbow colored
    pkg-config # https://github.com/sfackler/rust-openssl/issues/1663
    # compilers + interpreters
    gcc
    jdk
    rustup
    nodejs_20
    python3Full
    (python3.withPackages (python-pkgs: with python-pkgs; [
      virtualenv
    ]))

    ### only used without desktop environment
    font-manager
    copyq # clipboard manager
    networkmanagerapplet # tray icon for networking connection
    qview # image viewer
    audacious # audio player
    snapshot # camera
    gnome.dconf-editor # needed for home-manager gtk theming
    gnome.gnome-disk-utility
    gnome.nautilus # file manager
    gnome.sushi # thumbnails in nautilus
    xarchiver # archive manager
    lxde.lxmenu-data # required to discover applications
    lxde.lxsession # just needed for lxpolkit (an authentication agent)
    alsa-utils # control volume

    ### only used on xorg
    lxappearance # manage gtk theming stuff if homemanager fails
    picom-jonaburg # compositor
    unclutter-xfixes # hide mouse on inactivity
    pick-colour-picker
    # could/should work on wayland, but doesnt for now :(
    unstable.insomnia # rest api client
    barrier
    gparted

    ### only used on wayland
    nwg-look # manage gtk theming stuff if homemanager fails
    wev ydotool # find out / send keycodes
    libsForQt5.qt5.qtwayland qt6.qtwayland # hyprland must-haves
    variables.pkgs.hyprctl-collect-clients # bring all clients to one workspace
    variables.pkgs.hyprsome # awesome-like workspaces
    unstable.hyprpicker # color picker
    unstable.swaynotificationcenter
    unstable.swww # wallpaper switching with animations
    unstable.eww-wayland # build custom widgets
    unstable.grimblast # screenshot
    unstable.swayosd # osd for volume changes
    # lockscreen
    variables.pkgs.swaylock-effects
    unstable.swaylock-effects
  ];

  ###########################################
  ###########################################
  ########### PROGRAMS / SERVICES ###########
  ###########################################
  ###########################################

  # xorg
  services.xserver = {
    enable = true;
    layout = config.console.keyMap;

    # window manager / desktop environment
    windowManager.awesome.enable = true;

    # display manager
    displayManager.defaultSession = "hyprland";
    displayManager.sddm = {
      enable = true;
      theme = "sugar-candy";
    };
  };

  services.flatpak.enable = true;

  # for configuring gaming mice with piper
  services.ratbagd.enable = true;

  # remove background noise from mic
  programs.noisetorch.enable = true;

  # necessary for swaylock-effects
  security.pam.services.swaylock = {};

  # needed for trash to work in nautilus
  services.gvfs.enable = true;

  # bluez bluetooth gui
  services.blueman.enable = true;

  # for secret storing stuff
  services.gnome.gnome-keyring.enable = true;

  # default application for opening directories
  xdg.mime.defaultApplications."inode/directory" = "nautilus.desktop";

  # for mounting usb sticks and stuff
  services.udisks2.enable = true;

  # vm's with virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ variables.username ];

  # make some stuff in alacritty look better...? probably subjective
  fonts.fontconfig = {
    subpixel.rgba = "vrgb";
    hinting.style = "full"; # may cause loss of shape, try lower value?
  };

  services.onedrive = {
    enable = true;
    package = pkgs.unstable.onedrive;
  };

  # qt theming (based on gtk theming)
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };

  ### steam
  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam;
  };
  # currently needs this
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  ### hyprland (tiling wayland compositor)
  # make chromium / electron apps use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
  };

  ### use gtk desktop portal (if gnome is not enabled)
  # gnome will try to set a conflicting portal if enabled
  # using gtk desktop portal alongside hyprland desktop portal is also recommended
  xdg.portal = if !config.services.xserver.desktopManager.gnome.enable then {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  } else {};

  # use keyd to emulate ctrl+alt being equal to altgr,
  # like it is using a german keyboard layout on windows
  services.keyd.enable = true;
  services.keyd.keyboards.default = {
      ids = [ "*" ];
      settings."control+alt" = {
        "7" = "G-7"; # C-A-7 => {
        "8" = "G-8"; # C-A-8 => [
        "9" = "G-9"; # C-A-9 => ]
        "0" = "G-0"; # C-A-0 => }
        "-" = "G--"; # C-A-ß => \
        "]" = "G-]"; # C-A-+ => ~
      };
  };

  # fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # https://github.com/sfackler/rust-openssl/issues/1663
    set -x PKG_CONFIG_PATH ${pkgs.openssl.dev}/lib/pkgconfig

    # greeting (only in interactive shell)
    function fish_greeting

      set key_color   $(shuf -n 1 -e cyan magenta blue yellow green red)
      set title_color $(shuf -n 1 -e cyan magenta blue yellow green red)
      set logo_color  $(shuf -n 1 -e cyan magenta blue yellow green red)
      fastfetch -c /etc/dotfiles/fastfetch/short.jsonc --color-keys $key_color --color-title $title_color --logo-color-1 $logo_color

      fortune -sn 200

      # use starship prompt
      starship init fish | source

    end
  '';

  # starship prompt for fish
  programs.starship.enable = true;
  programs.starship.settings = {
    format = "$all$directory$character";
    add_newline = false;
    character = {
      # 𝈳 ᗇ ❯
      success_symbol = "[𝈳](purple)";
      error_symbol = "[𝈳](purple)";
    };
    cmd_duration = {
      min_time = 1000; # milliseconds
      format = "[[$duration](bold bright-black) execution time](bright-black)";
    };
    directory = {
      truncation_length = 1;
      truncate_to_repo = false;
      read_only_style = "black";
    };
  };

  ############################################
  ############################################
  ############### HOME-MANAGER ###############
  ############################################
  ############################################
  # manage stuff in /home/username/
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."${variables.username}" = {

  home.stateVersion = variables.version;
  # i dont know what this does?
  programs.home-manager.enable = true;

  ### gtk theming
  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    theme.name = "Fluent-Dark";
    font.name = "Noto Sans";
    font.size = 10;
  };
  # cursor
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 32;
  };
  gtk.cursorTheme = {
    name = "capitaine-cursors";
    size = 32;
  };

  # for play/pause current media player (and remembering last active player)
  services.playerctld.enable = true;

  # automatically mount usb sticks with notification and tray icon
  services.udiskie = {
    enable = true;
    automount = true;
    tray = "never"; # necessary when not having a tray
    notify = true;
  };

  # rofi (application launcher)
  programs.rofi = {
    enable = true;
    theme = "rofi"; # own theme
    package = pkgs.unstable.rofi-wayland; # wayland support
    terminal = "${pkgs.unstable.alacritty}/bin/alacritty";
  };

  # flameshot (screenshots on xorg)
  services.flameshot.enable = true;
  services.flameshot.settings.General = {
            uiColor  = "#FC618D";
    contrastUiColor  = "#5AD4E6";
    contrastOpacity  = 64;
    showHelp         = false;
    startupLaunch    = false;
    disabledTrayIcon = true;
  };

  # alacritty (terminal)
  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.unstable.alacritty;
  programs.alacritty.settings = {
    window.padding.x = 7;
    window.padding.y = 7;
    window.opacity = 0.5;
    window.dynamic_title = true;
    scrolling.multiplier = 5;
    cursor.style.shape = "Underline";
    # fix interactive features on remote ssh sessions that dont know about alacritty
    env.TERM = "xterm-256color";
    font = {
      normal.family = "FiraCode Nerd Font";
           normal.style = "Regular";
             bold.style = "Bold";
           italic.style = "Light";
      bold_italic.style = "Bold";
    };
    # color scheme based on vscodium theme "monokai pro (filter spectrum)"
    colors.primary = {
      background = "#1A191A";
      foreground = "#F7F1FF";
    };
    colors.normal = {
      black   = "#363537";
      red     = "#FC618D";
      green   = "#7BD88F";
      yellow  = "#FD9353";
      blue    = "#5AA0E6";
      magenta = "#948AE3";
      cyan    = "#5AD4E6";
      white   = "#F7F1FF";
    };
    colors.bright = {
      black   = "#69676C";
      red     = "#FB376F";
      green   = "#4ECA69";
      yellow  = "#FD721C";
      blue    = "#2180DE";
      magenta = "#7C6FDC";
      cyan    = "#37CBE1";
      white   = "#F7F1FF";
    };
  };

  # onedrive configuration
  home.file.".config/onedrive/config".text = ''
    # try to download changes from onedrive every x seconds
    monitor_interval = "6"
    # fully scan data for integrity every x attempt of downloading (monitor_interval)
    monitor_fullscan_frequency = "50"
    # minimum number of downloaded changes to trigger desktop notification
    min_notify_changes = "1"   
    # ignore temporary stuff and weird obsidian file
    skip_file = "~*|.~*|*.tmp|.OBSIDIANTEST"
  '';

  # git config mainly for credential stuff
  home.file.".gitconfig".text = ''
    [user]
      name = ${variables.secrets.git.name}
      email = ${variables.secrets.git.email}
    [init]
      defaultBranch = main
    [credential]
      credentialStore = secretservice
      helper = ${pkgs.unstable.git-credential-manager}/bin/git-credential-manager
  '';
};}
