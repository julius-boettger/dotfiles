# get mobile push notification for failing systemd services
args@{ config, lib, pkgs, ... }:
let
  port = 8523; # random port
  domain = "ntfy.juliusboettger.com";
in
lib.mkModule "ntfy" config {
  # on setup, do the following, and use password from bitwarden
  # sudo ntfy user add --role=admin admin

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${domain}";
      listen-http = ":${toString port}";
      web-root = "disable";
      # keep everything private by default
      auth-default-access = "deny-all";
      # create database for auth things here
      auth-file = "/var/lib/ntfy-sh/user.db";
    };
  };

  # secret environment file with password for admin user
  sops = {
    secrets.ntfy-admin.sopsFile = ./secrets.yaml;
    templates."ntfy.env".content = ''
      NTFY_ADMIN_PASSWORD=${config.sops.placeholder.ntfy-admin}
    '';
  };

  # make other systemd service call this:
  # systemd.services.my-service.onFailure = [ "notify-failure@%n.service" ];
  systemd.services."notify-failure@" = {
    description = "Send ntfy notification on service failure";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.sops.templates."ntfy.env".path;
      ExecStart = ''/bin/sh -c '${pkgs.curl}/bin/curl -u "admin:$NTFY_ADMIN_PASSWORD" -d "%i failed" https://${domain}/service-failed' '';
    };
  };

  # reverse-proxy
  local.website.extraConfig = ''
    ${domain} {
      reverse_proxy :${toString port}
    }
  '';
}