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
      version = "575.64.03";
      sha256_64bit = "sha256-S7eqhgBLLtKZx9QwoGIsXJAyfOOspPbppTHUxB06DKA=";
      sha256_aarch64 = "sha256-s2Jm2wjdmXZ2hPewHhi6hmd+V1YQ+xmVxRWBt68mLUQ=";
      openSha256 = "sha256-SAl1+XH4ghz8iix95hcuJ/EVqt6ylyzFAao0mLeMmMI=";
      settingsSha256 = "sha256-o8rPAi/tohvHXcBV+ZwiApEQoq+ZLhCMyHzMxIADauI=";
      persistencedSha256 = "sha256-/3OAZx8iMxQLp1KD5evGXvp0nBvWriYapMwlMSc57h8=";
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