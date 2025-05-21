args@{ pkgs, inputs, device, ... }:
let 
  mesa-pkgs = 
    pkgs;
    #inputs.hyprland.inputs.nixpkgs.legacyPackages.${device.system};
in
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
  hardware.graphics = {
    package   = mesa-pkgs              .mesa;
    package32 = mesa-pkgs.pkgsi686Linux.mesa;
  };
}
