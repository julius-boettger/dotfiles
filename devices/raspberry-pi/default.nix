args@{ pkgs, ... }:
{
  imports = [ ../../modules/base/raspberry-pi.nix ];

  # static ipv4 address over ethernet
  networking = {
    hostName = "nixos-pi";
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
    ### host some stuff
    website.enable = true;

    # has subdomain
    ntfy = { enable = true;              port = 8523; };
    immich = { enable = true;            port = 3000;
                                       ppport = 2135; };
    lamp-server.enable = true;         # port = 9000 hard-coded
    obsidian-livesync = { enable = true; port = 5984; };
    #ai-chatbot.enable = true; # configure port on next use

    # other
    terralux-backend.enable = true;  # port =  5000 hard-coded
    #blocky.enable = true;           # port =    53 dns
    #minecraft-server.enable = true; # port = 25565 default
  };
}
