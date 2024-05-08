# useful config / tools for laptops
args@{ pkgs, variables, secrets, ... }:
{
  # enable touchpad support
  services.xserver.libinput.enable = true;

}