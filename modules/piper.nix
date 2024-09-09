# configure gaming mice graphically
args@{ config, lib, pkgs, ... }:
lib.mkModule "piper" config {
  environment.systemPackages = [ pkgs.piper ];

  # runtime dependency
  services.ratbagd.enable = true;
}