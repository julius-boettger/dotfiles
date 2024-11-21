args@{ lib, pkgs, inputs, variables, device, ... }:
let
  # unstable nixpkgs input of hyprland to use for newer mesa drivers
  hyprland-pkgs-unstable = inputs.hyprland
    .inputs.nixpkgs.legacyPackages.${device.system};
  # nixpkgs to use for amd gpu mesa drivers
  mesa-pkgs = hyprland-pkgs-unstable;
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
    package   = mesa-pkgs              .mesa.drivers;
    package32 = mesa-pkgs.pkgsi686Linux.mesa.drivers;
    # additional vulkan drivers 
    extraPackages   = [ mesa-pkgs                 .amdvlk ];
    extraPackages32 = [ mesa-pkgs.driversi686Linux.amdvlk ];
  };
  # make sure hyprland desktop portal uses the right mesa version
  programs.hyprland.portalPackage = (lib.getPkgs "hyprland").xdg-desktop-portal-hyprland.override {
    inherit (mesa-pkgs) mesa;
  };
}
