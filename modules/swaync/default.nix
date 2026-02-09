# wayland notification daemon and center
args@{ config, lib, pkgs, ... }:
lib.mkModule "swaync" config {
  environment.systemPackages = with pkgs; [
    swaynotificationcenter
    socat # to listen to hyprland events for scripting
  ];

  # symlink config to ~/.config
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    xdg.configFile."swaync".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/swaync";
  };
}