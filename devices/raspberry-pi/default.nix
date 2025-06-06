args@{ pkgs, ... }:
{
  imports = [ ../../modules/base/raspberry-pi.nix ];

  # static ipv4 address over ethernet
  networking = {
    interfaces.end0.ipv4.addresses = [ {
      address = "192.168.178.254";
      prefixLength = 24;
    } ];
    # copied from automatically configured values
    nameservers = [ "192.168.178.1" ];
    defaultGateway = {
      address = "192.168.178.1";
      interface = "end0";
      metric = 100;
    };
  };

  local = {
    # host some stuff
    website.enable = true;
    lamp-server.enable = true;
    minecraft-server.enable = true;
    terralux-backend.enable = true;
    obsidian-livesync.enable = true;
    #blocky.enable = true;
    #ai-chatbot.enable = true;
  };

  environment.systemPackages = with pkgs; [
    htop # process viewer
    # monitor networking
    bmon
    nload
  ];
}