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
    inetutils # for telnet
    gnome.vinagre # for vnc connection
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

  # also remember to set GNS3's console application command
  # to something like `alacritty -T %d -e telnet %h %p`

  # and set VNC viewer to Vinagre
}