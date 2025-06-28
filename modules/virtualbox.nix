# manage VMs with virtualbox
args@{ config, lib, variables, ... }:
lib.mkModule "virtualbox" config {
  users.extraGroups.vboxusers.members = [ variables.username ];
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
}