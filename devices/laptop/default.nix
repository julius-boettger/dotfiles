args@{ pkgs, ... }:
{
  local = {
    base.gui.full.enable = true;
    base.laptop.enable = true;
    steam.enable = true;
  };

  # monitor config with xrandr command
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP --mode 1920x1200 --rate 120";

  # amd gpu
  hardware.amdgpu.initrd.enable = true;

  # attempt to fix fast battery discharge while suspended
  boot.kernelPackages = pkgs.linuxPackages_6_12;
}
