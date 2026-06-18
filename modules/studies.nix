# whatever I currently need for my studies
args@{ config, lib, pkgs, ... }:
lib.mkModule "studies" config {
  #local.devtools.docker.enable = true;

  # software analysis lab / cpachecker
  local.virt-manager.enable = true;
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  environment.systemPackages = with pkgs; [
    zotero
  ];
}
