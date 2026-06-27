# useful config for raspberry pi (5)
args@{ config, lib, pkgs, inputs, ... }:
{
  # import hardware-specific stuff
  imports = with inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5; [
    base
    page-size-16k # recommended
    display-vc4 # for connecting monitors
  ];

  nix.settings = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [ "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=" ];
  };

  # newer bootloader that supports multiple nixos generations
  boot.loader.raspberry-pi.bootloader = "kernel";
  # usually enabled by default config
  #boot.loader.systemd-boot.enable = lib.mkForce false;

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
