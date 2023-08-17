{ config, pkgs, ... }:

# variable definitions
let
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # for using unstable packages
  unstableTarball = fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz;
in {
  # import other nix files
  imports = [
    # results of automatic hardware scan
    ./hardware-configuration.nix
    # home-manager (channel has to be added first!)
    <home-manager/nixos>
  ];

  # version should be the same as channel versions (nixos and home-manager)
  system.stateVersion = "23.05";

  # self-explaining one-liners
  console.keyMap = "de";
  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
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
  # create new groups
  users.groups = {
    "${username}" = {};
  };
  # create user
  users.users."${username}" = {
    isNormalUser = true;
    description = displayname;
    extraGroups = [ # add user to groups (if they exist)
      username
      "users"
      "wheel"
      "networkmanager"
      "docker"
      "storage"
    ];
  };

  ##########################################
  ##########################################
  ################ PACKAGES ################
  ##########################################
  ##########################################

  # use packages from the unstable channel by prefixing them
  # with "unstable.", like "pkgs.unstable.onedrive"
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    unstable = import unstableTarball {
      config = config.nixpkgs.config;
    };
  };

  # fonts to install
  fonts.fonts = with pkgs; [
    noto-fonts # ~200 standard fonts for all kinds of languages
    noto-fonts-cjk-sans # for asian characters
    manrope # modern text
    # install only specific nerd fonts
    (nerdfonts.override { fonts = [
      "Iosevka"
      "FiraCode"
      "Terminus"
      "RobotoMono"
      "DroidSansMono" # vscode font
    ]; } )
  ];

  # packages to install
  environment.systemPackages = with pkgs; [
    ### gui
    #etcher # currently has insecure dependency
    unstable.stacer
    autokey
    font-manager
    pick-colour-picker
    refind
    vscode
    firefox-devedition-bin
    obsidian
    libreoffice
    barrier
    discord
    bitwarden
    gitkraken
    unstable.darktable
    gimp-with-plugins
    inkscape-with-extensions
    virtualbox
    jetbrains.idea-ultimate
    gparted
    veracrypt
    freefilesync
    spotify # use spotifywm for wm's? this is fine so far
    dconf # needed for home-manager gtk theming
    sioyek # pdf reader, also available as configurable program
    baobab # disk usage analyzer
    gnome.gnome-keyring # for authentication in vscode
    # to be replaced gnome stuff
    gnome.cheese # camera
    gnome.totem # video player
    rhythmbox # audio player
    gnome.eog # image viewer
    # for gtk theming
    lxappearance
    fluent-gtk-theme # theme
    capitaine-cursors # cursors
    papirus-icon-theme # icons
    
    ### cli
    gh # github
    git
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

    ### custom xorg desktop
    picom-jonaburg # compositor
    ulauncher # launcher
    pcmanfm # file manager
    unclutter-xfixes # hide mouse on inactivity
    lxde.lxmenu-data # required for awesome and pcmanfm to discover applications
    lxqt.lxqt-powermanagement # turn off monitors on idle
    lxde.lxsession # just needed for lxpolkit (an authentication agent)
    alsa-utils # control volume
    acpilight # for xbacklight, controls display brightness
    xsel # awesome-copycats dependency (might be unecessary)
    # circadian dependencies
    unstable.xssstate
    xprintidle
    pulseaudio # for pactl
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
    desktopManager.gnome.enable = true;
    #desktopManager.plasma5.enable = true;

    # monitor config
    displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --pos 0x150 --rate 60 --output DP-0 --mode 2560x1440 --pos 1920x0 --rate 143.86 --primary --preferred";
    # mouse sens config
    libinput.mouse.accelSpeed = "-0.7";
    # display manager
    displayManager.defaultSession = "none+awesome"; # somehow has to be this exact value?
    displayManager.sddm = {
      enable = true;
      #theme = "corners";
      #theme = "aerial-sddm";
      #theme = "sugar-candy";
    };
  };

  # bluez bluetooth gui
  services.blueman.enable = true;

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
    fortune | lolcat
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

  ### circadian (needs to be manually installed first!)
  # create own systemd service
  systemd.services.circadian = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Circadian power management service";
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = "${config.users.users."${username}".home}/.local/bin/circadian";
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

  # should be the same as current nixos and home-manager channel versions
  home.stateVersion = config.system.stateVersion;
  # i dont know what this does?
  programs.home-manager.enable = true;

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

  ### create symlinks to put dotfiles in the right locations
  # the following lines create symlinks of dotfiles of a
  # specific nixos generation to their right locations.
  # this means that you have to rebuild your nixos
  # configuration to make changes to these dotfiles
  # effective, which can become pretty annoying. the
  # alternative approach is to manually create symlinks
  # independent of nixos, like:
  # ln -s /etc/nixos/picom.conf ~/.config
  #home.file.".ideavimrc".source              = "/etc/nixos/.ideavimrc";
  #home.file.".config/awesome".source         = "/etc/nixos/awesome";
  #home.file.".config/picom.conf".source      = "/etc/nixos/picom.conf";
  #home.file.".config/autokey/phrases".source = "/etc/nixos/autokey-phrases";
};}
