# xorg compositor
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "picom" config {
  environment.systemPackages = [ pkgs.local.picom-jonaburg ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."picom.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/picom/picom.conf";
  };
}