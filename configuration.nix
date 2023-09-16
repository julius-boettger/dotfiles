{ config, pkgs, ... }:

# variable definitions
let
  # nixos state and home-manager version
  version = "23.05";
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # firefox profile to customize (directory in ~/.mozilla/firefox/)
  firefoxProfile = "h5hep79f.dev-edition-default";
  # my own packages
  mypkgs = {
    gitnuro          = pkgs.callPackage ./nix-packages/gitnuro.nix          {};
    circadian        = pkgs.callPackage ./nix-packages/circadian.nix        {};
    sddm-sugar-candy = pkgs.callPackage ./nix-packages/sddm-sugar-candy.nix {};
    symlink-dotfiles = pkgs.callPackage ./nix-packages/symlink-dotfiles.nix { inherit firefoxProfile username; };
  };
in {
  # import other nix files
  imports = [
    # results of automatic hardware scan
    ./hardware-configuration.nix
    # home-manager
    "${fetchTarball "https://github.com/nix-community/home-manager/archive/release-${version}.tar.gz"}/nixos"
  ];

  # self-explaining one-liners
  console.keyMap = "de";
  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = version;
  #services.printing.enable = true;

  # bootloader
  boot.loader = {
    timeout = 1;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # nvidia stuff
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # locale stuff
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

  ### mount data partition
  # make sure exfat is supported!
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/DATA";
    fsType = "exfat";
    options = [
      "nodev"
      "nosuid"
	    "nofail"
      "uid=1000"
      "gid=100"
    ];
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

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    settings.General = {
      Experimental = "true"; # "enables dbus experimental interfaces"
      FastConnectable = "true"; # connect faster but draw more power
      Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source"; # idk, from oaj
    };
  };

  ### user account and groups
  # create new group with username
  users.groups."${username}" = {};
  # create user
  users.users."${username}" = {
    isNormalUser = true;
    description = displayname;
    extraGroups = [ # add user to groups (if they exist)
      username
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
  fonts.fonts = with pkgs; [
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
    #etcher # currently has insecure dependency
    obs-studio
    unstable.stacer
    autokey
    font-manager
    pick-colour-picker
    refind
    unstable.vscode
    firefox-devedition
    obsidian
    libreoffice
    barrier
    discord
    bitwarden
    unstable.darktable
    gimp-with-plugins
    inkscape-with-extensions
    virtualbox
    jetbrains.idea-ultimate
    gparted
    veracrypt
    freefilesync
    spotify
    dconf # needed for home-manager gtk theming
    sioyek # pdf reader, also available as configurable program
    baobab # disk usage analyzer
    # to be replaced gnome stuff
    gnome.cheese # camera
    gnome.totem # video player
    rhythmbox # audio player
    gnome.eog # image viewer
    # gtk theme
    fluent-gtk-theme
    ### gtk icon theme
    ((papirus-icon-theme.override { /*folder-*/color = "black"; })
    # replace default firefox icons with firefox developer edition icons
    .overrideAttrs (attrs: {
      postInstall = (attrs.postInstall or "") + ''
        ln -sf $out/share/icons/Papirus/16x16/apps/firefox-developer-icon.svg $out/share/icons/Papirus/16x16/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/22x22/apps/firefox-developer-icon.svg $out/share/icons/Papirus/22x22/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/24x24/apps/firefox-developer-icon.svg $out/share/icons/Papirus/24x24/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/32x32/apps/firefox-developer-icon.svg $out/share/icons/Papirus/32x32/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/48x48/apps/firefox-developer-icon.svg $out/share/icons/Papirus/48x48/apps/firefox.svg
        ln -sf $out/share/icons/Papirus/64x64/apps/firefox-developer-icon.svg $out/share/icons/Papirus/64x64/apps/firefox.svg
      '';
    }))
    
    ### cli
    gitFull
    gh # github
    bash
    wget
    tree
    neofetch
    gphoto2fs # mount camera
    appimage-run # run app images on nixos
    cbonsai # ascii art bonsai
    asciiquarium # ascii art aquarium
    starship # shell prompt, install as program and package to set PATH
    fortune # random quote
    lolcat # make things rainbow colored
    # languages
    gcc
    jdk
    rustup
    nodejs_20
    python3Full
    (python3.withPackages (python-pkgs: with python-pkgs; [
      virtualenv
    ]))

    ### custom xorg desktop
    picom-jonaburg # compositor
    ulauncher # launcher
    pcmanfm # file manager
    xarchiver # archive manager (zip, tar, ...)
    unclutter-xfixes # hide mouse on inactivity
    lxde.lxmenu-data # required for awesome and pcmanfm to discover applications
    lxqt.lxqt-powermanagement # turn off monitors on idle
    lxde.lxsession # just needed for lxpolkit (an authentication agent)
    alsa-utils # control volume

    ### my own packages
    # command to create symlinks for dotfiles
    mypkgs.symlink-dotfiles
    # updated version of gitnuro of nixpkgs
    mypkgs.gitnuro
    # circadian + dependencies
    mypkgs.circadian
    unstable.xssstate
    xprintidle
    pulseaudio # for pactl
    # sddm theme + dependencies
    mypkgs.sddm-sugar-candy
    libsForQt5.qt5.qtgraphicaleffects
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

    # monitor config
    displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --pos 0x150 --rate 60 --output DP-0 --mode 2560x1440 --pos 1920x0 --rate 143.86 --primary --preferred";
    # mouse sens config
    libinput.mouse.accelSpeed = "-0.7";
    # display manager
    displayManager.defaultSession = "awesome";
    displayManager.session = [{
      name = "awesome";
      start = "awesome";
      manage = "desktop";
    }];
    displayManager.sddm = {
      enable = true;
      theme = "sugar-candy";
    };
  };

  # bluez bluetooth gui
  services.blueman.enable = true;

  # for vscode github account login
  services.gnome.gnome-keyring.enable = true;

  # for mounting usb sticks and stuff
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # make some stuff in alacritty look better...? probably subjective
  fonts.fontconfig = {
    subpixel.rgba = "vrgb";
    hinting.style = "hintfull"; # may cause loss of shape, try lower value?
  };

  # onedrive
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

  # fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # turn off fish greeting
    set fish_greeting
    # add ~/.local/bin to PATH
    export PATH="$PATH:$HOME/.local/bin" 
    # greeting
    neofetch --colors $(random 1 6) 7 7 $(random 1 6) --ascii_colors $(random 1 6) --ascii_distro nixos_small --package_managers off --os_arch off --distro_shorthand tiny --shell_version off --color_blocks off --disable theme --disable icons --disable font --disable resolution --disable cpu --disable gpu --disable memory
    fortune -sn 200
    # use starship prompt
    starship init fish | source
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

  ### circadian (my own package)
  # create systemd service
  systemd.services.circadian = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Circadian power management service";
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = "${mypkgs.circadian}/bin/circadian";
      Restart = "on-failure";
      # modify path for root user to find to nix binaries
      Environment="PATH=/run/current-system/sw/bin";
    };
  };
  # config file
  environment.etc."circadian.conf".text = ''
    [heuristics]
    tty_input = no
    x11_input = yes
    audio_block = yes
    max_cpu_load = 1.0
    process_block = ^dd$,^rsync$,^cp$,^mv$,^balena-etcher.bin$,^gparted$,^nixos-rebuild$,^nix-channel$,^nix-collect-garbage$,^git$,^gh$,^FreeFileSync$,^veracrypt$
    [actions]
    idle_time = 5m
    on_idle = "systemctl suspend"
  '';

  ############################################
  ############################################
  ############### HOME-MANAGER ###############
  ############################################
  ############################################
  # manage stuff in /home/username/
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."${username}" = {

  home.stateVersion = version;
  # i dont know what this does?
  programs.home-manager.enable = true;

  # gtk theming
  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    theme.name = "Fluent-Dark";
    font.name = "Noto Sans";
    font.size = 10;
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    name = "Capitaine Cursors";
    size = 32;
  };

  # flameshot (for screenshots)
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
  programs.alacritty.settings = {
    window.padding.x = 7;
    window.padding.y = 7;
    window.opacity = 0.5;
    window.dynamic_title = true;
    scrolling.multiplier = 5;
    cursor.style.shape = "Underline";
    font = {
      normal.family = "FiraCode Nerd Font";
      bold_italic.style = "Bold";
            normal.style = "Regular";
            italic.style = "Light";
              bold.style = "Bold";
    };
    # color scheme based on vscode theme "monokai pro (filter spectrum)"
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
  '';

  # firefox user.js to enable css theming
  home.file.".mozilla/firefox/${firefoxProfile}/user.js".text = ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
  '';
};}
