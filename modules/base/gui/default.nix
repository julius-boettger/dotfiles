# basic gui config (without unrelated programs)
args@{ config, lib, pkgs, variables, device, ... }:
let
  cfg = config.local.base.gui;
in
{
  options.local.base.gui.enable = lib.mkEnableOption "whether to enable basic gui config";

  config = lib.mkIf (cfg.enable || cfg.full.enable) {

    # latest kernel
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    # sound with pipewire
    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    ##########################################
    ##########################################
    ################ PACKAGES ################
    ##########################################
    ##########################################

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
      unstable.resources # system monitor (best overall)
      monitor # system monitor (best process view)
      psensor # gui for (lm_)sensors to display system temperatures
      vlc # video player
      qview # image viewer
      audacious # audio player
      snapshot # camera
      unstable.vesktop # wayland optimized discord client
      signal-desktop # messenger
      networkmanagerapplet # tray icon for networking connection
      xarchiver # archive manager
      baobab # disk usage analyzer
      gnome.gnome-disk-utility
      unstable.obsidian # PROPRIETARY notes
      spotify # PROPRIETARY
      # gtk theme
      (orchis-theme.override { border-radius = 10; })
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
      unclutter-xfixes # hide mouse on inactivity
      pick-colour-picker

      ### only used on wayland
      swww # wallpaper switching with animations
      grim # whole screen screenshot
      swappy # edit screenshots
      nwg-look # manage gtk theming stuff if homemanager fails
      hyprpicker # color picker
      wev ydotool # find out / send keycodes
      wl-clipboard # interact with clipboard 
      unstable.swayosd # osd for volume changes
      unstable.grimblast # region select screenshot
    ];

    ###########################################
    ###########################################
    ########### PROGRAMS / SERVICES ###########
    ###########################################
    ###########################################

    local = {
      vscodium.enable = true;
      alacritty.enable = true;
      hyprland.enable = true;
      awesome.enable = true;
      copyq.enable = true;
      eww.enable = true;
      rofi.enable = true;
      sddm-sugar-candy.enable = true;
      swaylock-effects.enable = true;
      swaync.enable = true;
      firefox.enable = true;
      gitnuro.enable = true;
      picom.enable = true;
      onedrive.enable = true;
      nautilus.enable = true;
      bluetooth.enable = true;
    };

    services.displayManager.sddm.enable = true;

    # configure various app settings
    programs.dconf.enable = true;

    # for mounting usb sticks and stuff
    services.udisks2.enable = true;

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
    home-manager.users.${variables.username} = { config, ... }: {
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

      # automatically mount usb sticks with notification and tray icon
      services.udiskie = {
        enable = true;
        automount = true;
        tray = "never"; # necessary when not having a tray
        notify = true;
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
    };
  };
}