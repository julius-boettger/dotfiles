# wayland notification daemon and center
args@{ config, lib, pkgs, inputs, variables, device, ... }:
lib.mkModule "swaync" config {
  environment.systemPackages = with pkgs; [
    unstable.swaynotificationcenter
    socat # to listen to hyprland events for scripting
  ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."swaync".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/swaync";
  };
}