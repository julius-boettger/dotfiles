# gns3 client + gns3 server (virtualbox vm) + utils
args@{ pkgs, variables, ... }:
let 
  # should point to nixpkgs commit dd5621df6dcb90122b50da5ec31c411a0de3e538
  # to get gns3-gui version 2.2.44.1
  gns3-gui = (args.getNixpkgs "nixpkgs-itsarch").gns3-gui;
in
{
  environment.systemPackages = with pkgs; [
    gns3-gui
    wireshark
    inetutils # for telnet
    gnome.vinagre # for vnc connection
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

  # also remember to change some GNS3 client preferences:
  # - console application command: alacritty -T %d -e telnet %h %p
  # - VNC viewer: Vinagre
}