# steam (PROPRIETARY)
args@{ config, lib, pkgs, ... }:
lib.mkModule "steam" config {
  programs.steam = {
    enable = true;
    package = (lib.getNixpkgs "nixpkgs-steam").steam;
  };

  # easy ge-proton setup for steam
  environment.systemPackages = [ pkgs.protonup-qt ];
}