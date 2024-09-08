# 
args@{ config, lib, pkgs, inputs, variables, device, ... }:
lib.mkModule "jetbrains" config {
  environment.systemPackages = with pkgs.jetbrains; [
    pycharm-community
    #idea-community
    #rust-rover
    #rider
  ];

  # symlink ideavim config to ~
  home-manager.users.${variables.username} = { config, ... }: {
    home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/jetbrains/.ideavimrc";
  };
}