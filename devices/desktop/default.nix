args@{ config, pkgs, variables, ... }:
{
  imports = [ ../../modules/studies ];

  local = {
    base.gui.full.enable = true;
    nvidia.enable = true;
    piper.enable = true;
    playerctl.enable = true;
  };

  # more swap, couldnt figure out how to change it using disko/btrfs
  swapDevices = [{
    device = "/.swapfile2";
    size = 16*1024; # 16 GB
  }];

  # for focusrite usb audio interface (get with `dmesg | grep Focusrite`)
  boot.extraModprobeConfig = "options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1";

  environment.systemPackages = with pkgs; [
    alsa-scarlett-gui # control center for focusrite usb audio interface
    liquidctl # liquid cooler control
    # to mount encrypted data partition
    zenity # password prompt
    cryptsetup # unlock luks
    dunst # send notifications
  ];

  # remove background noise from mic
  programs.noisetorch.enable = true;

  # symlink to home folder
  home-manager.users.${variables.username} = { config, ... }: {
    home.file."Library".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/Library";
  };

  # monitor config with xrandr command
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --pos 0x100 --rate 60 --output DP-0 --mode 2560x1440 --pos 1920x0 --rate 144 --primary --preferred";
  # mouse sens config
  services.libinput.mouse.accelSpeed = "-0.7";

  systemd.services.liquidctl = {
    enable = true;
    description = "set liquid cooler pump speed curve";
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = [
        "${pkgs.liquidctl}/bin/liquidctl initialize all"
        "${pkgs.liquidctl}/bin/liquidctl --match kraken set pump speed 30 55 40 100"
      ];
    };
    wantedBy = [ "default.target" ];
  };
  
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