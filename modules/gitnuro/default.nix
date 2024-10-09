# git gui
args@{ config, lib, pkgs, ... }:
lib.mkModule "gitnuro" config {
  environment.systemPackages = [ (pkgs.unstable.gitnuro.overrideAttrs (attrs: rec {
    version = "1.4.0";
    src = pkgs.fetchurl {
      url = "https://github.com/JetpackDuba/Gitnuro/releases/download/v${version}/Gitnuro-linux-x86_64-${version}.jar";
      hash = "sha256-9dqJUUsBOHGwdJ/xEnv0WPu8RXmWgguaWlSULqUH0go=";
    };
  })) ];
}