# git gui
args@{ config, lib, pkgs, ... }:
lib.mkModule "gitnuro" config {
  environment.systemPackages = [ (pkgs.unstable.gitnuro.overrideAttrs (attrs: rec {
    version = "1.5.0";
    src = pkgs.fetchurl {
      url = "https://github.com/JetpackDuba/Gitnuro/releases/download/v${version}/Gitnuro-linux-x86_64-${version}.jar";
      hash = "sha256-EoBjw98O5gO2wTO34KMiFeteryYapZC83MUfIqxtbmQ=";
    };
  })) ];
}