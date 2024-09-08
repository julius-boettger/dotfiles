# clipboard manager
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "copyq" config {
  environment.systemPackages = [ pkgs.copyq ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."copyq/copyq.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/copyq/copyq.conf";
  };
}