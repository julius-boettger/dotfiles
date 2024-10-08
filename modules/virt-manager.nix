# vm's with virt-manager + libvirtd + qemu + kvm
# based on https://nixos.wiki/wiki/Virt-manager
args@{ config, lib, variables, device, ... }:
lib.mkModule "virt-manager" config {
  programs.virt-manager.enable = true;

  # libvirtd
  virtualisation.libvirtd.enable = true;
  users.users.${variables.username}.extraGroups = [ "libvirtd" ];
  home-manager.users.${variables.username} = { config, ... }: {
    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}