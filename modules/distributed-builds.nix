# nix builds on remote machines
args@{ config, lib, ... }:
lib.mkModule "distributed-builds" config {
  # IMPORTANT: root user needs ssh access to target, meaning
  # e.g. `sudo ssh raspberry-pi echo test` has to work without
  # password prompt (e.g. by `sudo cp ~/.ssh/id* /root/.ssh/`)

  # use nix store of raspberry pi as cache for builds
  # to avoid locally repeating large builds that were
  # already done there
  nix.settings = {
    substituters = [ "ssh-ng://raspberry-pi" ];
  };

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