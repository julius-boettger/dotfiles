# git gui
args@{ config, lib, pkgs, ... }:
lib.mkModule "gitnuro" config {
  environment.systemPackages = [
    ((pkgs.gitnuro.override {
      jre = pkgs.jdk25;
    }).overrideAttrs (attrs: rec {
      version = "2.1.0";
      src = pkgs.fetchurl {
        url = "https://github.com/JetpackDuba/Gitnuro/releases/download/${version}/Gitnuro-linux-x86_64-2.1-2.1.0.jar";
        hash = "sha256-4NpKKrGvj9W6eMXsAXJYMoIJ5vvcBilwtNM5S+Ajfuc=";
      };
    }))
  ];
}