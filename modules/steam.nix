# steam (PROPRIETARY)
args@{ config, lib, pkgs, ... }:
lib.mkModule "steam" config {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };

  # easy ge-proton setup for steam
  environment.systemPackages = [ pkgs.protonup-qt ];
}