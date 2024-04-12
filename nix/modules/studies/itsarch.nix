# set up gns3 client and gns3 server as virtualbox vm
args@{
  pkgs, variables,
  # should point to nixpkgs commit dd5621df6dcb90122b50da5ec31c411a0de3e538
  # to get gns3-gui version 2.2.44.1
  pkgs-itsarch, ...
}:
{
  environment.systemPackages = with pkgs; [
    pkgs-itsarch.gns3-gui
    wireshark
  ];
  # wireshark permissions
  programs.wireshark.enable = true;
  users.extraGroups.wireshark.members = [ variables.username ];
  # virtualbox for gns3 server
  users.extraGroups.vboxusers.members = [ variables.username ];
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
}