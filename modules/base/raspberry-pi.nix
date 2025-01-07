### useful config for raspberry pi (5)
# not a toggleable module because raspberry-pi-nix should not be imported for all devices as it can cause a lot of conflicts.
# build an sd card image on the pi (running any os with nix) as a remote builder for the first installation with a command like
# nix build /etc/dotfiles#nixosConfigurations.DEVICE.config.system.build.sdImage --store ssh-ng://USER@IP
# then copy the built image from the remote pi to your local machine with scp. see more at
# https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_5#Using_the_Pi_5_as_a_remote_builder_to_build_native_ARM_packages_for_the_Pi_5
args@{ config, lib, pkgs, inputs, variables, ... }:
{
  ### fixes for default config
  # usually enabled in modules/base/default.nix, doesnt work here
  boot.loader.systemd-boot.enable = lib.mkForce false;
  # dont install networkmanager plugins because of
  # build failures and expensive cache misses
  networking.networkmanager.plugins = lib.mkForce [];

  # use nix-community/raspberry-pi-nix with cache
  imports = [ inputs.raspberry-pi-nix.nixosModules.raspberry-pi ];
  nix.settings = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
  raspberry-pi-nix = {
    board = "bcm2712"; # raspberry pi 5
    uboot.enable = false; # disable uboot as it just gets stuck
  };

  # avoid password prompts when remote rebuilding
  # https://github.com/NixOS/nixpkgs/issues/118655#issuecomment-1537131599
  security.sudo.extraRules = [ {
    users = [ variables.username ];
    commands = [
      { command = "/run/current-system/sw/bin/env";         options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/nix-env";     options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/systemd-run"; options = [ "NOPASSWD" ]; }
    ];
  } ];

  # set initial passwords of users to their names (dont forget to change!)
  users.users = {
    ${variables.username}.initialPassword = variables.username;
                     root.initialPassword = "root";
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
}
