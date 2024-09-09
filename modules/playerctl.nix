# control media player with mpris
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "playerctl" config {
  environment.systemPackages = [ pkgs.playerctl ];

  # to remember last active player
  home-manager.users.${variables.username} = { config, ... }: {
    services.playerctld.enable = true;
  };
}