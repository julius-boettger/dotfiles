# for nvidia gpu
args@{ config, lib, pkgs, ... }:
lib.mkModule "nvidia" config {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = false;
    # pin driver version https://www.nvidia.com/en-us/drivers/unix/
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.126.18";
      sha256_64bit = "sha256-p3gbLhwtZcZYCRTHbnntRU0ClF34RxHAMwcKCSqatJ0=";
      sha256_aarch64 = "sha256-pruxWQlLurymRL7PbR24NA6dNowwwX35p6j9mBIDcNs=";
      openSha256 = "sha256-1Q2wuDdZ6KiA/2L3IDN4WXF8t63V/4+JfrFeADI1Cjg=";
      settingsSha256 = "sha256-QMx4rUPEGp/8Mc+Bd8UmIet/Qr0GY8bnT/oDN8GAoEI=";
      persistencedSha256 = "sha256-ZBfPZyQKW9SkVdJ5cy0cxGap2oc7kyYRDOeM0XyfHfI=";
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