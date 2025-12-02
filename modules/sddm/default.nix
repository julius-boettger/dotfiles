# sddm (display manager) + theme
args@{ config, lib, pkgs, ... }:
lib.mkModule "sddm" config {
  services.displayManager.sddm = {
    enable = true;
    theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
  };
  environment.systemPackages = with pkgs; [
    qt6.qtmultimedia # necessary for some reason
  ];   
}
