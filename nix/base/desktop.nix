# this file contains shared config i want to have on desktop (gui) devices
args@{ pkgs, variables, local-pkgs, ... }:
let
  barrierPort = args.secrets.barrier.port;
in
{
  # self-explaining one-liners
  imports = [ ../modules/vscodium.nix ];
  boot.supportedFilesystems = [ "ntfs" "exfat" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = args.lib.mkIf (barrierPort != null) [ barrierPort ];
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

  ### bluetooth
  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = "true"; # necessary for some functionality
      FastConnectable = "true"; # connect faster but draw more power
    };
  };
  # avoid warning in bluetooth service
  systemd.services."bluetooth".serviceConfig.ConfigurationDirectoryMode = 755;

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
    local-pkgs.gitnuro # git gui (newer version compared to nixpkgs)
    ventoy # create bootable usb sticks
    usbimager # if ventoy causes problems
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
    unstable.bruno # rest api client
    signal-desktop # messenger
    spotify # PROPRIETARY
    pdfstudio2023 # PROPRIETARY
    obsidian # PROPRIETARY
    # sddm theme + dependency (login manager)
    local-pkgs.sddm-sugar-candy
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

    ### cli
    playerctl # pause media with mpris
    lm_sensors # system temperature sensor info
    dunst # for better notify-send with dunstify
    gphoto2fs # mount camera

    ### only used without desktop environment
    font-manager
    rofimoji # emoji picker for rofi
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
    barrier # kvm switch
    gparted # partition manager

    ### only used on wayland
    socat # for hyprland workspaces with eww
    nwg-look # manage gtk theming stuff if homemanager fails
    wev ydotool # find out / send keycodes
    wl-clipboard # interact with clipboard 
    libsForQt5.qt5.qtwayland qt6.qtwayland # hyprland must-haves
    local-pkgs.hyprctl-collect-clients # bring all clients to one workspace
    local-pkgs.hyprsome # awesome-like workspaces
    unstable.hyprpicker # color picker
    unstable.swaynotificationcenter
    unstable.swww # wallpaper switching with animations
    unstable.eww # build custom widgets
    unstable.grim # whole screen screenshot
    unstable.grimblast # region select screenshot
    unstable.swayosd # osd for volume changes
    unstable.swappy # edit screenshots
    # lockscreen
    local-pkgs.swaylock-effects
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
    layout = args.config.console.keyMap;

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

  # bluez bluetooth gui (has some other config with home-manager later!)
  services.blueman.enable = true;

  # default application for opening directories
  xdg.mime.defaultApplications."inode/directory" = "nautilus.desktop";

  # for mounting usb sticks and stuff
  services.udisks2.enable = true;

  # shell alias for shorter fastfetch
  environment.shellAliases.fastfetch-short = "fastfetch -c /etc/dotfiles/fastfetch/short.jsonc";

  # set env var to show battery indicator (if configured)
  environment.variables.SHOW_BATTERY_INDICATOR = args.lib.mkIf args.device.showBatteryIndicator "1";

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
  environment.variables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
  };
  # use gtk desktop portal
  # (recommended for usage alongside hyprland desktop portal)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

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
  home-manager.users."${variables.username}" = { config, ... }:
  let
    symlink = config.lib.file.mkOutOfStoreSymlink;
  in
  {

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

  # bluez bluetooth gui (was enabled earlier!)
  # disable notifications when a device (dis)connects
  dconf.settings."org/blueman/general".plugin-list = [ "!ConnectionNotifier" ];

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
  # rofimoji
  xdg.configFile."rofimoji.rc".text = ''
    action = copy
    skin-tone = neutral
  '';
  # firefox (allow userChrome.css)
  home.file."./.mozilla/firefox/${args.device.firefoxProfile}/user.js".text = ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
  '';

  ### symlink dotfiles
  # files in ~/.config/
  xdg.configFile = {
    "eww"                     = { source = symlink "/etc/dotfiles/eww";     recursive = true; };
    "awesome"                 = { source = symlink "/etc/dotfiles/awesome"; recursive = true; };
    "swaync"                     .source = symlink "/etc/dotfiles/swaync";
    "hypr/hyprland.conf"         .source = symlink "/etc/dotfiles/hyprland/hyprland.conf";
    "fastfetch/config.jsonc"     .source = symlink "/etc/dotfiles/fastfetch/default.jsonc";   
    "picom.conf"                 .source = symlink "/etc/dotfiles/other/picom.conf";
    "copyq/copyq.conf"           .source = symlink "/etc/dotfiles/other/copyq.conf";
    "VSCodium/User/settings.json".source = symlink "/etc/dotfiles/other/vscodium.json";
    "alacritty/alacritty.toml"   .source = symlink "/etc/dotfiles/other/alacritty.toml";
  };
  # files somewhere else in ~/
  home.file = {
    ".ideavimrc".source = symlink "/etc/dotfiles/other/.ideavimrc";
    ".local/share/rofi/themes".source = symlink "/etc/dotfiles/rofi";
    ".mozilla/firefox/${args.device.firefoxProfile}/chrome/userChrome.css".source = symlink "/etc/dotfiles/other/firefox.css";
  };
};}