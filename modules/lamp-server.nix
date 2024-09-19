# server to control govee rgb lamp
args@{ config, lib, variables, device, ... }:
let
  lamp-server-pkg = (lib.getPkgs "lamp-server").lamp-server.override {
    # override govee api secrets 
    govee_api_key = "";
    govee_device  = "";
    govee_model   = "";
  };
in 
lib.mkModule "lamp-server" config {

  environment.systemPackages = [ lamp-server-pkg ];
  networking.firewall.allowedTCPPorts = [ 9000 ];

  systemd.services.lamp-server = {
    enable = true;
    description = "server to control govee rgb lamp";
    serviceConfig = {
      User = variables.username;
      ExecStart = "${lamp-server-pkg}/bin/lamp-server";
    };
    wantedBy = [ "multi-user.target" ];
  };
}