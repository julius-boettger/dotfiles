# nix builds on remote machines
# https://wiki.nixos.org/wiki/Distributed_build
args@{ config, lib, variables, ... }:
lib.mkModule "distributed-builds" config {
  nix = {
    distributedBuilds = true;
    settings = {
      trusted-users = [ variables.username ];
      # useful when remote has faster internet than local machine
      builders-use-substitutes = true;
    };
    buildMachines = [
      {
        hostName = "raspberry-pi";
        system = "aarch64-linux";
        protocol = "ssh-ng"; # nix' custom ssh variant
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
  };

  # convenient ssh hostnames
  # dont forget `ssh-copy-id HOST`!
  programs.ssh.extraConfig = ''
    Host raspberry-pi
      Hostname 192.168.178.254
      User ${variables.username}
  '';
}