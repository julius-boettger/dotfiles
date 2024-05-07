args@{ pkgs, variables, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop-utils.nix
  ];

  # auto generated, idk, necessary?
  boot.initrd.luks.devices."luks-abee1c20-f86a-419d-8f38-f32c71c0ae16".device = "/dev/disk/by-uuid/abee1c20-f86a-419d-8f38-f32c71c0ae16";
  # show loading animation during boot with plymouth
  boot.initrd.systemd.enable = true; # run plymouth early
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
}
