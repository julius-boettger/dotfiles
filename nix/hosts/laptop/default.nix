{ config, pkgs, variables, ... }:
{
  # results of automatic hardware scan
  imports = [ ./hardware-configuration.nix ];
  # enable touchpad support
  services.xserver.libinput.enable = true;
  # auto generated, idk
  boot.initrd.luks.devices."luks-a06582aa-e5cb-46a1-bd33-5aa451ab6e44".device = "/dev/disk/by-uuid/a06582aa-e5cb-46a1-bd33-5aa451ab6e44";
  # show loading animation during boot with plymouth
  boot.initrd.systemd.enable = true; # run plymouth early
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
}
