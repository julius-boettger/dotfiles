# server to control smart plug for reptile terrarium lamp
args@{ config, lib, ... }:
let
  port = 5000; # currently hard-coded in server
  terralux-backend-pkg = (lib.getPkgs "terralux-backend").terralux-backend;
in 
lib.mkModule "terralux-backend" config {

  environment.systemPackages = [ terralux-backend-pkg ];
  networking.firewall.allowedTCPPorts = [ port ];

  systemd.services.terralux-backend = {
    enable = true;
    description = "server to control smart plug for reptile terrarium lamp";
    serviceConfig = {
      User = config.username;
      ExecStart = "${terralux-backend-pkg}/bin/terralux-backend";
    };
    wantedBy = [ "multi-user.target" ];
  };
}