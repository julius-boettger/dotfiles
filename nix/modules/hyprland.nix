# hyprland (tiling wayland compositor)
args@{ pkgs, variables, device, ... }:
let
  hyprland-pkgs = args.getPkgs "hyprland";
in
{
  programs.hyprland = {
    enable = true;
    package = hyprland-pkgs.hyprland;
  };

  # make chromium / electron apps use wayland
  environment.variables.NIXOS_OZONE_WL = "1";

  # use gtk desktop portal
  # (recommended for usage alongside hyprland desktop portal)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # must-haves according to hyprland wiki
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtwayland
               qt6.qtwayland
  ];

  # use cached hyprland flake builds
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # with home manager
  home-manager.users."${variables.username}" = { config, ... }:
  let
    symlink = config.lib.file.mkOutOfStoreSymlink;
  in
  {
    # home manager module to configure plugins
    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland-pkgs.hyprland;
      plugins = [];
    };

    # symlink config
    xdg.configFile = {
      "hypr/hyprland.conf"    .source = symlink "/etc/dotfiles/hyprland/hyprland.conf";
      "hypr/extra-config.conf".source = symlink "/etc/dotfiles/nix/devices/${device.internalName}/hyprland.conf";
    };
  };
}