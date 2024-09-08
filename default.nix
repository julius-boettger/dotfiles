# 
args@{ config, lib, pkgs, inputs, variables, device, ... }:
lib.mkModule "" config {
  environment.systemPackages = [  ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/";
  };

  # symlink config to ~
  home-manager.users.${variables.username} = { config, ... }: {
    home.file."".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/";
  };
}