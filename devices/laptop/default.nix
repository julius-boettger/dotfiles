args@{ pkgs, inputs, variables, device, ... }:
let
  # unstable packages (input) of hyprland for newer mesa drivers
  hyprland-pkgs-unstable = inputs.hyprland
    .inputs.nixpkgs.legacyPackages.${device.system};
in
{
  local = {
    base = {
      gui.full.enable = true;
      laptop.enable = true;
    };
    plymouth.enable = true;
  };

  # monitor config with xrandr command
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP --mode 1920x1200 --rate 120";

  # autologin hyprland
  services.displayManager.sddm.settings.Autologin = {
    User = variables.username;
    Session = "hyprland.desktop";
  };

  # amd gpu
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl = {
    enable = true;
    driSupport      = true;
    driSupport32Bit = true;
    # newer drivers compatible with hyprland
    package   = hyprland-pkgs-unstable              .mesa.drivers;
    package32 = hyprland-pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };
}
