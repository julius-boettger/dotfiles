# git gui
args@{ config, lib, pkgs, ... }:
lib.mkModule "gitnuro" config {
  environment.systemPackages = [
    ((pkgs.gitnuro.override {
      jre = pkgs.jdk25;
    }).overrideAttrs (attrs: rec {
      version = "2.0.0-beta01";
      src = pkgs.fetchurl {
        url = "https://github.com/JetpackDuba/Gitnuro/releases/download/${version}/Gitnuro-linux-x86_64-2.0-beta01-2.0.0.jar";
        hash = "sha256-DAvZdKV82mYa09WiBnxVRgb8XucWg3UQjXEc7CO8gO8=";
      };
    }))
  ];
}