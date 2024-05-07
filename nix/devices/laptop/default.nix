args@{ pkgs, variables, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop-utils.nix
  ];

  # show loading animation during boot with plymouth
  boot.initrd.systemd.enable = true; # run plymouth early
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
}
