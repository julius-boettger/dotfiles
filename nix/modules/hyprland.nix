# hyprland (tiling wayland compositor)
args@{ pkgs, variables, device, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
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

  # symlink config
  home-manager.users."${variables.username}" = { config, ... }:
  let
    symlink = config.lib.file.mkOutOfStoreSymlink;
  in
  {
    xdg.configFile = {
      "hypr/hyprland.conf"    .source = symlink "/etc/dotfiles/hyprland/hyprland.conf";
      "hypr/extra-config.conf".source = symlink "/etc/dotfiles/nix/devices/${device.internalName}/hyprland.conf";
    };
  };
}