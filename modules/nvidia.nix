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
      version = "570.144";
      sha256_64bit = "sha256-wLjX7PLiC4N2dnS6uP7k0TI9xVWAJ02Ok0Y16JVfO+Y=";
      sha256_aarch64 = "sha256-6kk2NLeKvG88QH7/YIrDXW4sgl324ddlAyTybvb0BP0=";
      openSha256 = "sha256-PATw6u6JjybD2OodqbKrvKdkkCFQPMNPjrVYnAZhK/E=";
      settingsSha256 = "sha256-VcCa3P/v3tDRzDgaY+hLrQSwswvNhsm93anmOhUymvM=";
      persistencedSha256 = "sha256-hx4w4NkJ0kN7dkKDiSOsdJxj9+NZwRsZEuhqJ5Rq3nM=";
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