# wayland lockscreen
args@{ config, lib, pkgs, ... }:
lib.mkModule "swaylock-effects" config {
  environment.systemPackages = with pkgs; [
    unstable.swaylock-effects
    (lib.writeScriptFile "swaylock-effects" ./swaylock-effects.sh)
  ];

  # necessary!
  security.pam.services.swaylock = {};
}