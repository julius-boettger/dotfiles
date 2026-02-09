# server to control govee rgb lamp
args@{ config, lib, ... }:
let
  port = 9000; # currently hard-coded in server
  lamp-server-pkg = (lib.getPkgs "lamp-server").lamp-server;
in 
lib.mkModule "lamp-server" config {

  environment.systemPackages = [ lamp-server-pkg ];
  networking.firewall.allowedTCPPorts = [ port ];

  systemd.services.lamp-server = {
    enable = true;
    description = "server to control govee rgb lamp";
    serviceConfig = {
      User = config.username;
      ExecStart = "${lamp-server-pkg}/bin/lamp-server";
    };
    wantedBy = [ "multi-user.target" ];
  };

  local.website.extraConfig = ''
    lamp.juliusboettger.com {
      reverse_proxy :${toString port}
    }
  '';

  # configure secrets
  sops = {
    # get govee api secrets from local sops file secrets.yaml
    secrets = {
      govee_api_key = { sopsFile = ./secrets.yaml; };
      govee_device  = { sopsFile = ./secrets.yaml; };
      govee_model   = { sopsFile = ./secrets.yaml; };
    };
    # write config file for with secrets
    templates."lamp-server.yaml" = {
      path = "/home/${config.username}/.config/lamp-server.yaml";
      owner = config.username;
      content = ''
        govee_api_key: "${config.sops.placeholder.govee_api_key}"
        govee_device: "${config.sops.placeholder.govee_device}"
        govee_model: "${config.sops.placeholder.govee_model}"
      '';
    };
  };
}