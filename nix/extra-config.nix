/* this file is for device-specific configuration.
   the following is some example content you might want to configure. */

{ config, pkgs, ... }:

# import config variables that are shared by all of my devices
let variables = import ./variables.nix pkgs.callPackage;
in {
  # for nvidia gpu
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # for suspend on hyprland
    powerManagement.enable = true;
    # for kernel module, not nouveau drivers!
    # should usually be `true`, but is
    # currently "marked as broken"
    open = false; 
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  services.xserver = {
    # monitor config with xrandr command
    displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --pos 0x100 --rate 144 --output DP-0 --mode 2560x1440 --pos 1920x0 --rate 144 --primary --preferred";
    # mouse sens config
    libinput.mouse.accelSpeed = "-0.7";
  };
}