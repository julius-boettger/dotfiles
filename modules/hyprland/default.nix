# hyprland (tiling wayland compositor)
args@{ config, lib, pkgs, variables, device, ... }:
let
  package = (lib.getPkgs "hyprland").hyprland;
  plugins = [
    # better multi-monitor workspaces
    (lib.getPkgs "hyprsplit").hyprsplit
  ];
in
lib.mkModule "hyprland" config {
  programs.hyprland = {
    enable = true;
    inherit package;
  };

  services.displayManager.defaultSession = "hyprland";

  # make chromium / electron apps use wayland
  environment.variables.NIXOS_OZONE_WL = "1";

  # use gtk desktop portal
  # (recommended for usage alongside hyprland desktop portal)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    # must-haves according to hyprland wiki
    libsForQt5.qt5.qtwayland
               qt6.qtwayland
    # move all hyprland clients to a single workspace
    (lib.writeScriptFile "hyprctl-collect-clients" /etc/dotfiles/modules/hyprland/hyprctl-collect-clients.sh)
  ];

  # use cached hyprland flake builds
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # home manager module
  home-manager.users.${variables.username} = { config, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      inherit package plugins;
      # write config file that imports real config
      extraConfig = ''
        source = /etc/dotfiles/devices/${device.internalName}/hyprland.conf
        source = /etc/dotfiles/modules/hyprland/hyprland.conf
      '';
      # tell systemd to import environment by default
      # this e.g. can fix screenshare by making sure hyprland desktop portal gets its required variables
      systemd.variables = [ "--all" ];
    };

    # lock before/after entering sleep with swaylock-effects
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # set command for loginctl
          lock_cmd = "swaylock-effects";
        } // (if device.internalName == "laptop" then {
          # for laptops: lock before going to sleep, which shows the lockscreen
          #              shortly, but you dont see it if you close the laptop lid
          before_sleep_cmd = "loginctl lock-session";
        } else {
          # otherwise: lock after resuming from sleep, so you
          #            dont see the lockscreen before resuming
          
          # after resuming, there is split second of time before
          # the session is locked. to secure this, inhibit input
          # with a hyprland keybind submap for this time
          before_sleep_cmd = "hyprctl dispatch submap inhibit-input";
          after_sleep_cmd = "swaylock-effects; hyprctl dispatch submap reset";
        });

        # hypridle complains if there are no listeners,
        # so i made this one which does nothing
        listener = {
          timeout = 999999999999999999;
          on-timeout = "";
          on-resume = "";
        };
      };
    };
  };
}