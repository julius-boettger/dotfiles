args@{ config, pkgs, variables, ... }:
{
  imports = [ ../../modules/studies ];

  local = {
    base = {
      cli.full.enable = true;
      gui.full.enable = true;
    };
    nvidia.enable = true;
  };

  boot.supportedFilesystems.ntfs = true;

  # for focusrite usb audio interface (get with `dmesg | grep Focusrite`)
  boot.extraModprobeConfig = "options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1";

  # drivers for aio liquid coolers
  boot.extraModulePackages = with config.boot.kernelPackages; [ liquidtux ];
  boot.kernelModules = [ "liquidtux" ];

  environment.systemPackages = with pkgs; [
    alsa-scarlett-gui # control center for focusrite usb audio interface
    liquidctl # liquid cooler control
    # to mount encrypted data partition
    gnome.zenity # password prompt
    cryptsetup # unlock luks
    dunst # send notifications
  ];

  ### mount data partition
  boot.supportedFilesystems.exfat = true;
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/DATA";
    fsType = "exfat";
    options = [
      "nodev"
      "nosuid"
      "nofail"
      "uid=1000"
      "gid=100"
    ];
  };
  # symlink to home folder
  home-manager.users.${variables.username} = { config, ... }: {
    home.file."Library".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/Library";
  };

  # monitor config with xrandr command
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --pos 0x100 --rate 144 --output DP-0 --mode 2560x1440 --pos 1920x0 --rate 144 --primary --preferred";
  # mouse sens config
  services.libinput.mouse.accelSpeed = "-0.7";
  
  # openrgb
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
  systemd.services.openrgb-sleep-wrapper = {
    enable = true;
    description = "turn off rgb before entering sleep and turn it back on when waking up";
    unitConfig = {
      Before = "sleep.target";
      StopWhenUnneeded = "yes";
    };
    serviceConfig = {
      User = variables.username;
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "-${pkgs.openrgb}/bin/openrgb -p off";
      ExecStop  = "-${pkgs.openrgb}/bin/openrgb -p default";
    };
    wantedBy = [ "sleep.target" ];
  };
}