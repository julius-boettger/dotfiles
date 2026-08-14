### useful config for raspberry pi (5)
# first build and flash initial sd-card image using:
# nix build /etc/dotfiles#nixosConfigurations.raspberry-pi.config.system.build.sdImage
# then lookup sd-card block device name using `lsblk` (e.g. sda) and write the built image to it:
# zstd -dc result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
args@{ config, lib, pkgs, inputs, ... }:
{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    sd-image # enable building sd-card image
    trusted-nix-caches

    raspberry-pi-5.base
    raspberry-pi-5.display-vc4 # for connecting monitors
    raspberry-pi-5.page-size-16k # recommended
    #raspberry-pi-5.bluetooth
  ];

  # newer bootloader that supports multiple nixos generations
  boot.loader.raspberry-pi.bootloader = "kernel";
  # usually enabled by default config
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # add bootloader name and kernel version to nixos generation names
  system.nixos.tags = with config.boot; [
    loader.raspberry-pi.bootloader
    kernelPackages.kernel.version
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    # increase max allowed concurrent sessions for remote rebuilds
    settings = {
      MaxStartups = "100:30:200";
      MaxSessions = 100;
    };
  };

  # disable sound
  services.pipewire = {
    audio.enable = false;
    alsa.enable = false;
    jack.enable = false;
    pulse.enable = false;
  };

  # set initial passwords of users to their names (dont forget to change!)
  users.users = {
    ${config.username}.initialPassword = config.username;
    root.initialPassword = "root";
  };

  # dont install networkmanager plugins because of
  # build failures and expensive cache misses
  networking.networkmanager.plugins = lib.mkForce [];

  local.unattended-rebuild.enable = true;
  environment.systemPackages = with pkgs; [
    tmux
    htop # process viewer
    # monitor networking
    bmon
    nload
  ];

  # avoid warning
  boot.zfs.forceImportRoot = false;
}
