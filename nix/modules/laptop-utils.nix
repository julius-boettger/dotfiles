# useful tools for laptops
args@{ pkgs, variables, ... }:
{
  # enable touchpad support
  services.xserver.libinput.enable = true;
}