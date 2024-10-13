# dns proxy to block ads and trackers
args@{ config, lib, ... }:
lib.mkModule "blocky" config {

  # open dns ports
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.blocky = {
    enable = true;
    settings = {
      upstreams = {
        init.strategy = "failOnError";
        groups.default = [ "192.168.178.1" ];
      };

      blocking = {
        clientGroupsBlock.default = [ "general" ];
        blackLists.general = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ];
      };
    };
  };
}