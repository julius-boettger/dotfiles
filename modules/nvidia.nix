# for nvidia gpu
args@{ config, lib, pkgs, ... }:
lib.mkModule "nvidia" config {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = false;
    # pin driver version https://www.nvidia.com/en-us/drivers/unix/
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.133.07";
      sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
      sha256_aarch64 = "sha256-yTovUno/1TkakemRlNpNB91U+V04ACTMwPEhDok7jI0=";
      openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
      persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";
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
  hardware.nvidia.open = false;

  environment.systemPackages = with pkgs; [
    egl-wayland # recommended by https://wiki.hyprland.org/Nvidia/
    nvidia-system-monitor-qt # monitor nvidia gpu stuff
  ];
}