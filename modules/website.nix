# host own website
args@{ config, lib, ... }:
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
      # change port of admin api from (default: 5000)
      globalConfig = "admin :23673";
      logFormat = "level INFO";
      extraConfig = ''
        https:// {
          tls /etc/ssl/certs/certificate.pem /etc/ssl/private/key.pem
        }

        juliusboettger.com, www.juliusboettger.com {
          root * ${(lib.getPkgs "website").website}
          file_server
        }

        # to easily fetch e.g. .vimrc 
        dotfiles.juliusboettger.com {
          redir https://raw.githubusercontent.com/julius-boettger/dotfiles/refs/heads/main{uri}
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