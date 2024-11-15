# git gui
args@{ config, lib, pkgs, ... }:
lib.mkModule "gitnuro" config {
  environment.systemPackages = [ (pkgs.unstable.gitnuro.overrideAttrs (attrs: rec {
    version = "1.4.2";
    src = pkgs.fetchurl {
      url = "https://github.com/JetpackDuba/Gitnuro/releases/download/v${version}/Gitnuro-linux-x86_64-${version}.jar";
      hash = "sha256-1lwuLPR6b1+I2SWaYaVrZkMcYVRAf1R7j/AwjQf03UM=";
    };
  })) ];
}