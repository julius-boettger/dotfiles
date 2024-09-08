# basic gui config (without unrelated programs)
args@{ config, lib, pkgs, variables, device, ... }:
{
  options.local.base.gui.enable = lib.mkEnableOption "whether to enable basic gui config";

  imports = [
    ../../hyprland
  ];

  config = lib.mkIf config.local.base.gui.enable {

    # nvidia driver fails to build on latest kernel
    #boot.kernelPackages = pkgs.linuxPackages_latest;

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
      gparted # partition manager, use with sudo -E gparted
      unstable.alacritty # terminal
      unstable.gitnuro # git gui
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
      baobab # disk usage analyzer
      gnome.gnome-disk-utility
      unstable.nautilus # file manager
      gnome.sushi # thumbnails in nautilus
      unstable.obsidian # PROPRIETARY notes
      spotify # PROPRIETARY
      # gtk theme
      (orchis-theme.override { border-radius = 10; })
      # sddm theme + dependency (login manager)
      local.sddm-sugar-candy
      libsForQt5.qt5.qtgraphicaleffects
      # icon themes
      gnome.adwaita-icon-theme # just having this installed fixes issues with some apps
      (papirus-icon-theme.override { /*folder-*/color = "black"; })

      ### cli
      alsa-utils # control volume
      lm_sensors # system temperature sensor info
      lxde.lxmenu-data # required to discover applications
      lxde.lxsession # just needed for lxpolkit (an authentication agent)

      ### only used on xorg
      lxappearance # manage gtk theming stuff if homemanager fails
      local.picom-jonaburg # compositor
      unclutter-xfixes # hide mouse on inactivity
      pick-colour-picker
      # could/should work on wayland, but doesnt for now :(
      barrier # kvm switch

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
      unstable.hyprland-workspaces # for hyprland + eww integration
      unstable.swaynotificationcenter
      # open eww desktop widget on all monitors
      (lib.writeScriptFile "eww-open-everywhere" /etc/dotfiles/modules/eww/scripts/open-everywhere.sh)
      # move all hyprland clients to a single workspace
      (lib.writeScriptFile "hyprctl-collect-clients" /etc/dotfiles/modules/hyprland/hyprctl-collect-clients.sh)
      # lockscreen
      unstable.swaylock-effects
      (lib.writeScriptFile "swaylock-effects" /etc/dotfiles/modules/swaylock-effects/swaylock-effects.sh)
      (lib.writeScript "lock-suspend"   "swaylock-effects && systemctl suspend"  )
      (lib.writeScript "lock-hibernate" "swaylock-effects && systemctl hibernate")
    ];

    ###########################################
    ###########################################
    ########### PROGRAMS / SERVICES ###########
    ###########################################
    ###########################################

    # xorg
    services.xserver = {
      enable = true;
      xkb.layout = args.config.console.keyMap;
      windowManager.awesome.enable = true;
    };

    services.displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        theme = "sugar-candy";
      };
    };

    # enable self-written options
    local.vscodium.enable = true;

    services.onedrive.enable = true;

    # configure various app settings
    programs.dconf.enable = true;

    # necessary for swaylock-effects
    security.pam.services.swaylock = {};

    # needed for trash to work in nautilus
    services.gvfs.enable = true;

    # bluez bluetooth gui (has some other config with home-manager later!)
    services.blueman.enable = true;

    # default application for opening directories
    xdg.mime.defaultApplications."inode/directory" = "nautilus.desktop";

    # disable docker (enabled in cli config)
    virtualisation.docker = {
      rootless.enable = args.lib.mkForce false;
              enable = args.lib.mkForce false;
    };

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
      "eww"                     = { source = symlink "/etc/dotfiles/modules/eww";     recursive = true; };
      "awesome"                 = { source = symlink "/etc/dotfiles/modules/awesome"; recursive = true; };
      "swaync"                     .source = symlink "/etc/dotfiles/modules/swaync";
      "fastfetch/config.jsonc"     .source = symlink "/etc/dotfiles/devices/${device.internalName}/fastfetch/default.jsonc";
      "picom.conf"                 .source = symlink "/etc/dotfiles/modules/picom/picom.conf";
      "copyq/copyq.conf"           .source = symlink "/etc/dotfiles/modules/copyq/copyq.conf";
      "VSCodium/User/settings.json".source = symlink "/etc/dotfiles/modules/vscodium/vscodium.json";
      "alacritty/alacritty.toml"   .source = symlink "/etc/dotfiles/modules/alacritty/alacritty.toml";
    };
    # files somewhere else in ~/
    home.file = {
      ".ideavimrc".source = symlink "/etc/dotfiles/modules/jetbrains/.ideavimrc";
      ".local/share/rofi/themes".source = symlink "/etc/dotfiles/modules/rofi";
      ".mozilla/firefox/default/chrome/userChrome.css".source = symlink "/etc/dotfiles/modules/firefox/firefox.css";
    };
  };};
}