# host own website
args@{ config, lib, variables, device, ... }:
lib.mkModule "website" config {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    logFormat = "level INFO";
    extraConfig = ''
      https:// {
        tls /etc/ssl/certs/certificate.pem /etc/ssl/private/key.pem
      }

      juliusboettger.com, www.juliusboettger.com {
        root * ${(lib.getPkgs "website").website}
        file_server
      }

      # fallback
      *.juliusboettger.com {
        respond 404
      }
    '';
  };
}