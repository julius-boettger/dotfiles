# nix builds on remote machines
args@{ config, lib, ... }:
lib.mkModule "distributed-builds" config {
  # enable cross-compilation to aarch64 (on x86_64)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # convenient ssh hostnames
  # dont forget `ssh-copy-id HOST`!
  programs.ssh.extraConfig = ''
    Host raspberry-pi
      Hostname 192.168.178.254
      User ${config.username}
  '';
}