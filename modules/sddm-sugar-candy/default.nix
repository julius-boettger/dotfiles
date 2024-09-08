# sddm (login manager) theme
args@{ config, lib, pkgs, ... }:
lib.mkModule "sddm-sugar-candy" config {
  services.displayManager.sddm.theme = "sugar-candy";

  environment.systemPackages = with pkgs; [ 
    local.sddm-sugar-candy
    libsForQt5.qt5.qtgraphicaleffects # runtime dependency
  ];
}