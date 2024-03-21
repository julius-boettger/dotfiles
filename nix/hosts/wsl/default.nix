{ pkgs, ... }:
let
  variables = import ./../../variables.nix pkgs.callPackage;
in {
  wsl = {
    enable = true;
    defaultUser = variables.username;
  };

  # for issues with company network
  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];
  boot.tmp.cleanOnBoot = true;
}