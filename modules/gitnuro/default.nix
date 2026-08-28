# git gui
args@{ config, lib, pkgs, ... }:
lib.mkModule "gitnuro" config {
  environment.systemPackages = [
    ((pkgs.gitnuro.override {
      jre = pkgs.jdk25;
    }).overrideAttrs (attrs: rec {
      version = "2.0.0-beta02";
      src = pkgs.fetchurl {
        url = "https://github.com/JetpackDuba/Gitnuro/releases/download/${version}/Gitnuro-linux-x86_64-2.0-beta02-2.0.0.jar";
        hash = "sha256-tCi2NaQmZUm5/deiTJJDir9HlGSwQvZPKoR1Y5JSqls=";
      };
    }))
  ];
}