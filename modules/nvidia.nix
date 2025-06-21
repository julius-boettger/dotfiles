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
      version = "570.169";
      sha256_64bit = "sha256-XzKoR3lcxcP5gPeRiausBw2RSB1702AcAsKCndOHN2U=";
      sha256_aarch64 = "sha256-s8jqaZPcMYo18N2RDu8zwMThxPShxz/BL+cUsJnszts=";
      openSha256 = "sha256-oqY/O5fda+CVCXGVW2bX7LOa8jHJOQPO6mZ/EyleWCU=";
      settingsSha256 = "sha256-0E3UnpMukGMWcX8td6dqmpakaVbj4OhhKXgmqz77XZc=";
      persistencedSha256 = "sha256-dttFu+TmbFI+mt1MbbmJcUnc1KIJ20eHZDR7YzfWmgE=";
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