# steam (PROPRIETARY)
args@{ config, lib, pkgs, ... }:
lib.mkModule "steam" config {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };

  # reduce synchronization overhead in proton/wine
  boot.kernelModules = [ "ntsync" ];

  # easy ge-proton setup for steam
  environment.systemPackages = [ pkgs.protonup-qt ];
}