### nix builds on remote machines
# dont forget `ssh-copy-id USER@IP`!
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
      # raspberry pi
      {
        protocol = "ssh-ng"; # nix' custom ssh variant
        system = "aarch64-linux";
        sshUser = variables.username; # on remote
        hostName = "192.168.178.254";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
  };
}