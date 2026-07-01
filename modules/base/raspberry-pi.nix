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

  # avoid password prompts when remote rebuilding
  # https://github.com/NixOS/nixpkgs/issues/118655#issuecomment-1537131599
  security.sudo.extraRules = [ {
    users = [ config.username ];
    commands = [
      { command = "/run/current-system/sw/bin/env";         options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/nix-env";     options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/systemd-run"; options = [ "NOPASSWD" ]; }
    ];
  } ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
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

  systemd.services.unattended-nixos-rebuild = {
    description = "Weekly NixOS rebuild";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake /etc/nixos#${config.name}";
    };
  };
  systemd.timers.unattended-nixos-rebuild = {
    description = "Run NixOS rebuild weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sat 03:00";
      Persistent = true; # catch up if host was off
    };
  };
}
