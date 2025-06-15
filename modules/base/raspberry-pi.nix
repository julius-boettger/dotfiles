### useful config for raspberry pi (5)
# not a toggleable module because raspberry-pi-nix should not be imported for all devices as it can cause a lot of conflicts.
# build an sd card image on the pi (running any os with nix) as a remote builder for the first installation with a command like
# nix build /etc/dotfiles#nixosConfigurations.DEVICE.config.system.build.sdImage --store ssh-ng://USER@IP
# then copy the built image from the remote pi to your local machine with scp. see more at
# https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_5#Using_the_Pi_5_as_a_remote_builder_to_build_native_ARM_packages_for_the_Pi_5
args@{ config, lib, pkgs, inputs, variables, ... }:
{
  # import hardware-specific fixes
  imports = [ inputs.nixos-hardware.nixosModules.raspberry-pi-5 ];
  # compatible kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  # compatible boot loader
  boot.loader = {
    generic-extlinux-compatible.enable = true;
    # usually enabled by default config
    systemd-boot.enable = lib.mkForce false;
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
    ${variables.username}.initialPassword = variables.username;
                     root.initialPassword = "root";
  };

  # dont install networkmanager plugins because of
  # build failures and expensive cache misses
  networking.networkmanager.plugins = lib.mkForce [];
}
