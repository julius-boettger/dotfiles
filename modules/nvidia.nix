# for nvidia gpu
args@{ config, lib, pkgs, ... }:
lib.mkModule "nvidia" config {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = false;

    # https://mynixos.com/nixpkgs/option/hardware.nvidia.branch
    #branch = "latest";

    # need at 595.84 for some gaming things

    # pin driver version https://www.nvidia.com/en-us/drivers/unix/
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.104.02";
      sha256_64bit = "sha256-5CHCAuTHn1jDx/MWG75xRU67PYiTb4ggWg4yfNBMWco=";
      sha256_aarch64 = "sha256-PafStmwNMufeDp3VtpTGGCoW+53Gor/mieO1m1pI7gI=";
      openSha256 = "sha256-FWk5ra2yjz8VAxAA8GXrSoeBj/XC1BKvsKsBKR09joE=";
      settingsSha256 = "sha256-4Kxro6tvI5aX4nu2RspgyBsW+Jq3/VYjSAS5UGdzTCU=";
      persistencedSha256 = "sha256-JsMLPqJuZwAtHngsQODMsmgO7F2tVkQ2arc7fYa2bwo=";
    };
  };

  boot.kernelParams = [
    # for suspend/wakeup issues, recommended by https://wiki.hyprland.org/Nvidia/
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # for wayland issues, but breaks tty
    # see https://github.com/NixOS/nixpkgs/issues/343774#issuecomment-2370293678
    "initcall_blacklist=simpledrm_platform_driver_init"
  ];

  # for suspend/wakeup issues, recommended by https://wiki.hyprland.org/Nvidia/
  hardware.nvidia.powerManagement.enable = true;

  environment.systemPackages = with pkgs; [
    nvidia-system-monitor-qt # monitor nvidia gpu stuff
  ];
}