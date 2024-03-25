{ config, pkgs, variables, ... }:
{
  environment.variables.NIX_FLAKE_DEFAULT_HOST = "laptop";

  # results of automatic hardware scan
  imports = [ ./hardware-configuration.nix ];

  # enable touchpad support
  services.xserver.libinput.enable = true;
  # auto generated, idk, necessary?
  boot.initrd.luks.devices."luks-abee1c20-f86a-419d-8f38-f32c71c0ae16".device = "/dev/disk/by-uuid/abee1c20-f86a-419d-8f38-f32c71c0ae16";
  # show loading animation during boot with plymouth
  boot.initrd.systemd.enable = true; # run plymouth early
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
}
