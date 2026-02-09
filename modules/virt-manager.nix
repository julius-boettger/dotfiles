# vm's with virt-manager + libvirtd + qemu + kvm
# based on https://nixos.wiki/wiki/Virt-manager
args@{ config, lib, ... }:
lib.mkModule "virt-manager" config {
  programs.virt-manager.enable = true;

  # libvirtd
  virtualisation.libvirtd.enable = true;
  users.users.${config.username}.extraGroups = [ "libvirtd" ];
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}