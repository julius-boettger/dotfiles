# more gui config i don't want on every device
args@{ pkgs, variables, local-pkgs, device, ... }:
let
  # helper functions to make a shell script
  # conveniently available under a given name (globally)
  script = pkgs.writeShellScriptBin;
  script-file = name: path: script name (builtins.readFile(path));
in
{
  imports = [
    ../../modules/vscodium.nix
    ../../modules/hyprland.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # not sure for which package, but this is necessary for some reason
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  fonts.packages = with pkgs; [
    noto-fonts # ~200 standard modern fonts for all kinds of languages
    noto-fonts-cjk-sans # for asian characters
    aileron # modern text with 16 variations
    # install only specific nerd fonts
    (nerdfonts.override { fonts = [
      "JetBrainsMono" # good for code
    ]; } )
  ];

  environment.systemPackages = with pkgs; [
    ### gui
    unstable.alacritty # terminal
    local-pkgs.gitnuro # git gui (newer version compared to nixpkgs)
    unstable.resources # system monitor (best overall)
    monitor # system monitor (best process view)
    psensor # gui for (lm_)sensors to display system temperatures
    vlc # video player
    qview # image viewer
    audacious # audio player
    snapshot # camera
    unstable.vesktop # wayland optimized discord client
    signal-desktop # messenger
    rofimoji # emoji picker for rofi
    copyq # clipboard manager
    networkmanagerapplet # tray icon for networking connection
    xarchiver # archive manager
    gnome.dconf-editor # needed for home-manager gtk theming
    baobab # disk usage analyzer
    gnome.gnome-disk-utility
    unstable.gnome.nautilus # file manager
    gnome.sushi # thumbnails in nautilus
    spotify # PROPRIETARY
    obsidian # PROPRIETARY
    # gtk theme
    (orchis-theme.override { border-radius = 10; })
    # sddm theme + dependency (login manager)
    local-pkgs.sddm-sugar-candy
    libsForQt5.qt5.qtgraphicaleffects
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
    alsa-utils # control volume
    lm_sensors # system temperature sensor info
    lxde.lxmenu-data # required to discover applications
    lxde.lxsession # just needed for lxpolkit (an authentication agent)

    ### only used on xorg
    lxappearance # manage gtk theming stuff if homemanager fails
    picom-jonaburg # compositor
    unclutter-xfixes # hide mouse on inactivity
    pick-colour-picker
    # could/should work on wayland, but doesnt for now :(
    barrier # kvm switch
    gparted # partition manager

    ### only used on wayland
    swww # wallpaper switching with animations
    socat # for hyprland workspaces with eww
    grim # whole screen screenshot
    swappy # edit screenshots
    nwg-look # manage gtk theming stuff if homemanager fails
    hyprpicker # color picker
    wev ydotool # find out / send keycodes
    wl-clipboard # interact with clipboard 
    unstable.eww # build custom widgets
    unstable.swayosd # osd for volume changes
    unstable.grimblast # region select screenshot
    unstable.swaynotificationcenter
    local-pkgs.hyprsome # awesome-like workspaces for hyprland
    # move all hyprland clients to a single workspace
    (script-file "hyprctl-collect-clients" /etc/dotfiles/scripts/hyprctl-collect-clients.sh)
    # lockscreen
    unstable.swaylock-effects
    (script-file "swaylock-effects" /etc/dotfiles/scripts/swaylock-effects.sh)
    (script "lock-suspend"   "swaylock-effects && systemctl suspend"  )
    (script "lock-hibernate" "swaylock-effects && systemctl hibernate")
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

  # make some stuff in alacritty look better...? probably subjective
  fonts.fontconfig = {
    subpixel.rgba = "vrgb";
    hinting.style = "full"; # may cause loss of shape, try lower value?
  };

  # what to do when pressing power button
  services.logind = {
    powerKeyLongPress = "poweroff";
    # do nothing :) suspend manually if you want
    powerKey = "ignore";
  };

  # qt theming (based on gtk theming)
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
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

  # browser
  programs.firefox = {
    enable = true;
    # allow custom css
    profiles.default.settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

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

  ### symlink dotfiles
  # files in ~/.config/
  xdg.configFile = {
    "eww"                     = { source = symlink "/etc/dotfiles/eww";     recursive = true; };
    "awesome"                 = { source = symlink "/etc/dotfiles/awesome"; recursive = true; };
    "swaync"                     .source = symlink "/etc/dotfiles/swaync";
    "fastfetch/config.jsonc"     .source = symlink "/etc/dotfiles/nix/devices/${device.internalName}/fastfetch/default.jsonc";
    "picom.conf"                 .source = symlink "/etc/dotfiles/other/picom.conf";
    "copyq/copyq.conf"           .source = symlink "/etc/dotfiles/other/copyq.conf";
    "VSCodium/User/settings.json".source = symlink "/etc/dotfiles/other/vscodium.json";
    "alacritty/alacritty.toml"   .source = symlink "/etc/dotfiles/other/alacritty.toml";
  };
  # files somewhere else in ~/
  home.file = {
    ".ideavimrc".source = symlink "/etc/dotfiles/other/.ideavimrc";
    ".local/share/rofi/themes".source = symlink "/etc/dotfiles/rofi";
    ".mozilla/firefox/default/chrome/userChrome.css".source = symlink "/etc/dotfiles/other/firefox.css";
  };
};}