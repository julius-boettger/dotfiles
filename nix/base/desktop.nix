# this file contains shared config i want to have on desktop (gui) devices
{ config, pkgs, variables, host, ... }:
{
  # self-explaining one-liners
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.kernelPackages = pkgs.linuxPackages_6_7;

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

  console = {
    earlySetup = true;
    keyMap = "de";
    colors = [
      "000000" "FC618D" "7BD88F" "FD9353" "5AA0E6" "948AE3" "5AD4E6" "F7F1FF"
      "99979B" "FB376F" "4ECA69" "FD721C" "2180DE" "7C6FDC" "37CBE1" "FFFFFF"
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

  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = "true"; # "enables dbus experimental interfaces"
      FastConnectable = "true"; # connect faster but draw more power
      Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source"; # idk, from oaj
    };
  };

  ##########################################
  ##########################################
  ################ PACKAGES ################
  ##########################################
  ##########################################

  # fonts to install
  fonts.packages = with pkgs; [
    noto-fonts # ~200 standard modern fonts for all kinds of languages
    noto-fonts-cjk-sans # for asian characters
    aileron # modern text with 16 variations
    # install only specific nerd fonts
    (nerdfonts.override { fonts = [
      "JetBrainsMono" # good for code
    ]; } )
  ];

  # packages to install
  environment.systemPackages = with pkgs; [
    ### gui
    bitwarden # password manager
    obs-studio # video recording
    libreoffice # office suite
    gimp-with-plugins # image editor
    firefox-devedition # browser
    jetbrains.idea-community # java ide
    unstable.alacritty # terminal
    bottles # run windows software easily
    pitivi # video editor
    tenacity # audio recorder and editor
    piper # configure gaming mice graphically with ratbagd
    protonup-qt # easy ge-proton setup for steam
    variables.pkgs.gitnuro # newer version compared to nixpkgs
    ventoy # create bootable usb sticks
    unstable.resources # system monitor (best overall)
    monitor # system monitor (best process view)
    psensor # gui for (lm_)sensors to display system temperatures
    darktable # photo editor and raw developer
    inkscape-with-extensions # vector graphic editor
    veracrypt # disk encryption
    freefilesync # file backup
    vlc # video player
    sioyek # pdf reader, also available as programs.sioyek in hm
    baobab # disk usage analyzer
    unstable.vesktop # wayland optimized discord client
    spotify # PROPRIETARY
    pdfstudio2023 # PROPRIETARY
    obsidian # PROPRIETARY
    # sddm theme + dependency (login manager)
    variables.pkgs.sddm-sugar-candy
    libsForQt5.qt5.qtgraphicaleffects
    # gtk themes
    fluent-gtk-theme
    (orchis-theme.override { border-radius = 10; })
    (colloid-gtk-theme.override { tweaks = [ "normal" ]; })
    # icon themes
    gnome.adwaita-icon-theme # just having this installed fixes issues with some apps
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
    # codium with extensions (text editor)
    (vscode-with-extensions.override {
      vscode = unstable.vscodium;
      vscodeExtensions = with vscode-extensions; [
        # for syntax highlighting / language support
        bbenoist.nix
        ms-python.python 
        ms-vscode.cpptools
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
        ms-python.vscode-pylance # more python (PROPRIETARY)
        pkief.material-icon-theme # file icon theme
        christian-kohler.path-intellisense # auto complete paths
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # solve leetcode problems
        { name = "vscode-leetcode";
          publisher = "LeetCode";
          version = "0.18.1";
          sha256 = "Ym9Gi9nL0b5dJq0yXbX2NvSW89jIr3UFBAjfGT9BExM="; }
        # monokai theme (PROPRIETARY)
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
        # meson syntax highlighting
        { name = "mesonbuild";
          publisher = "mesonbuild";
          version = "1.21.0";
          sha256 = "hsWb1ES2V/e1gp3bQML4TaOiB/XQ8QH6LCI5ZWvsm5I="; }
      ];
    })

    ### cli
    playerctl # pause media with mpris
    lm_sensors # system temperature sensor info
    dunst # for better notify-send with dunstify
    gphoto2fs # mount camera

    ### only used without desktop environment
    font-manager
    copyq # clipboard manager
    networkmanagerapplet # tray icon for networking connection
    qview # image viewer
    audacious # audio player
    snapshot # camera
    gnome.dconf-editor # needed for home-manager gtk theming
    gnome.gnome-disk-utility
    unstable.gnome.nautilus # file manager
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
    insomnia # rest api client
    barrier # kvm switch
    gparted # partition manager

    ### only used on wayland
    socat # for hyprland workspaces with eww
    nwg-look # manage gtk theming stuff if homemanager fails
    wev ydotool # find out / send keycodes
    libsForQt5.qt5.qtwayland qt6.qtwayland # hyprland must-haves
    variables.pkgs.hyprctl-collect-clients # bring all clients to one workspace
    variables.pkgs.hyprsome # awesome-like workspaces
    unstable.hyprpicker # color picker
    unstable.swaynotificationcenter
    unstable.swww # wallpaper switching with animations
    unstable.eww # build custom widgets
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

  services.onedrive.enable = true;

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

  # default application for opening directories
  xdg.mime.defaultApplications."inode/directory" = "nautilus.desktop";

  # for mounting usb sticks and stuff
  services.udisks2.enable = true;

  # shell alias for shorter fastfetch
  environment.shellAliases.fastfetch-short = "fastfetch -c /etc/dotfiles/fastfetch/short.jsonc";

  # vm's with virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ variables.username ];

  # make some stuff in alacritty look better...? probably subjective
  fonts.fontconfig = {
    subpixel.rgba = "vrgb";
    hinting.style = "full"; # may cause loss of shape, try lower value?
  };

  # qt theming (based on gtk theming)
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };

  ### steam (PROPRIETARY)
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
    package = pkgs.hyprland;
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

  ############################################
  ############################################
  ############### HOME-MANAGER ###############
  ############################################
  ############################################
  home-manager.users."${variables.username}" = { config, ... }: {

  ### theming
  gtk.enable = true;
  # gtk theme
  gtk.theme.name = "Orchis-Dark";
  # icon theme
  gtk.iconTheme.name = "Papirus-Dark";
  # font config
  gtk.font.name = "Noto Sans";
  gtk.font.size = 10;
  # cursor theme
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
    theme = "transparent"; # own theme
    package = pkgs.rofi-wayland; # wayland support
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

  ### create dotfiles
  # onedrive
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
  # firefox (allow userChrome.css)
  home.file."./.mozilla/firefox/${host.firefoxProfile}/user.js".text = ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
  '';

  ### symlink dotfiles
  # files in ~/.config/
  xdg.configFile = {
    "eww"                     = { source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/eww";     recursive = true; };
    "awesome"                 = { source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/awesome"; recursive = true; };
    "swaync"                     .source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/swaync";
    "hypr/hyprland.conf"         .source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/hyprland/hyprland.conf";
    "fastfetch/config.jsonc"     .source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fastfetch/default.jsonc";   
    "picom.conf"                 .source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/picom.conf";
    "copyq/copyq.conf"           .source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/copyq.conf";
    "VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/vscodium.json";
    "alacritty/alacritty.toml"   .source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/alacritty.toml";
  };
  # files somewhere else in ~/
  home.file = {
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/.ideavimrc";
    ".local/share/rofi/themes".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/rofi";
    ".mozilla/firefox/${host.firefoxProfile}/chrome/userChrome.css".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/firefox.css";
  };
};}