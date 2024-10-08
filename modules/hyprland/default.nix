# hyprland (tiling wayland compositor)
args@{ config, lib, pkgs, variables, device, ... }:
let
  package = (lib.getPkgs "hyprland").hyprland;
  plugins = [
    # better multi-monitor workspaces
    (lib.getPkgs "split-monitor-workspaces").split-monitor-workspaces
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
  };
}