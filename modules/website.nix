# host own website
args@{ config, lib, variables, device, ... }:
let
  cfg = config.local.website;
in
{
  options.local.website = {
    enable = lib.mkEnableOption "whether to enable website";
    extraConfig = lib.mkOption { type = lib.types.lines; };
  };

  config = lib.mkIf cfg.enable {
  
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

        ${cfg.extraConfig}

        # fallback
        *.juliusboettger.com {
          respond 404
        }
      '';
    };
  };
}