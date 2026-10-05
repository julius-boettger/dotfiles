# whatever I currently need for my studies
args@{ config, lib, pkgs, ... }:
lib.mkModule "studies" config {
  #local.devtools.docker.enable = true;

  environment.systemPackages = with pkgs; [
    anki
    zotero
    pympress
  ];

  # for viper (install manually)
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    programs.vscodium.mutableExtensionsDir = lib.mkForce true;
  };
}
