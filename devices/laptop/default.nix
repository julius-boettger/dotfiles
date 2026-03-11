args@{ pkgs, inputs, ... }:
let 
  mesa-pkgs = 
    pkgs;
    #inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in
{
  local = {
    base.gui.full.enable = true;
    base.laptop.enable = true;
  };

  swapDevices = [ {
    device = "/.swapfile";
    size = 4000; # 4 GB
  } ];

  # monitor config with xrandr command
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP --mode 1920x1200 --rate 120";

  ### amd gpu
  hardware = {
    amdgpu = {
      opencl.enable = true;
      # load drivers early in boot process
      initrd.enable = true;
    };
    graphics = {
      package   = mesa-pkgs              .mesa;
      package32 = mesa-pkgs.pkgsi686Linux.mesa;
    };
  };
}
