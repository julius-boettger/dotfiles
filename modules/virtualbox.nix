# manage VMs with virtualbox
args@{ config, lib, variables, ... }:
lib.mkModule "virtualbox" config {
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ variables.username ];
  # https://discourse.nixos.org/t/issue-with-virtualbox-in-24-11/57607
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
}