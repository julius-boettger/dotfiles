# server to control smart plug for reptile terrarium lamp
args@{ config, lib, variables, device, ... }:
let
  internalPort = 5000; # currently hard-coded in server
  externalPort = 5001; # only exposed to local net
  terralux-backend-pkg = (lib.getPkgs "terralux-backend").terralux-backend;
in 
lib.mkModule "terralux-backend" config {

  environment.systemPackages = [ terralux-backend-pkg ];
  networking.firewall.allowedTCPPorts = [ externalPort ];

  local.website.extraConfig = ''
    http://:${toString externalPort} {
      reverse_proxy :${toString internalPort}
    }
  '';

  systemd.services.terralux-backend = {
    enable = true;
    description = "server to control smart plug for reptile terrarium lamp";
    serviceConfig = {
      User = variables.username;
      ExecStart = "${terralux-backend-pkg}/bin/terralux-backend";
    };
    wantedBy = [ "multi-user.target" ];
  };
}