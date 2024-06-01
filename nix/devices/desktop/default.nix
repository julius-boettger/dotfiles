args@{ pkgs, variables, ... }:
{
  imports = [
    #./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems.ntfs = true;

  # for focusrite usb audio interface (get with `dmesg | grep Focusrite`)
  boot.extraModprobeConfig = "options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1";

  # drivers for aio liquid coolers
  boot.extraModulePackages = with args.config.boot.kernelPackages; [ liquidtux ];
  boot.kernelModules = [ "liquidtux" ];

  environment.systemPackages = with pkgs; [
    # to mount encrypted data partition
    gnome.zenity # password prompt
    cryptsetup # unlock luks
    dunst # send notifications

    nvidia-system-monitor-qt # monitor nvidia gpu stuff
    alsa-scarlett-gui # control center for focusrite usb audio interface
    liquidctl # liquid cooler control
    unigine-valley # PROPRIETARY gpu stress test and benchmark
    mprime # PROPRIETARY cpu stress test
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
  home-manager.users."${variables.username}" = { config, ... }: {
    home.file."Library".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/Library";
  };

  ### for nvidia gpu
  # load some nvidia stuff early into the boot process, helps with plymouth
  #boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # for suspend on hyprland
    powerManagement.enable = true;
    # for kernel module, not nouveau drivers!
    # should usually be `true`, but is
    # currently "marked as broken"
    open = false; 
    # pin driver version https://www.nvidia.com/en-us/drivers/unix/
    /*package = args.config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.42.02";
      sha256_64bit   = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA="; 
      # dont actually need values
      openSha256 = "";
      persistencedSha256 = "";
    };*/
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