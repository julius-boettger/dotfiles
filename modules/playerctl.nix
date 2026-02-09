# control media player with mpris
args@{ config, lib, pkgs, ... }:
lib.mkModule "playerctl" config {
  environment.systemPackages = [ pkgs.playerctl ];

  # to remember last active player
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    services.playerctld.enable = true;
  };
}