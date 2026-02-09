# whatever I currently need for my studies
args@{ config, lib, pkgs, ... }:
lib.mkModule "studies" config {
  #local.devtools.docker.enable = true;

  environment.systemPackages = with pkgs; [
    #zotero
  ];
}
