# photo management
args@{ config, lib, ... }:
let
  cfg = config.local.immich;
in
{
  options.local.immich = {
    enable = lib.mkEnableOption "whether to enable immich";
    port = lib.mkOption { type = lib.types.port; };
    ppport = lib.mkOption { type = lib.types.port; };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = cfg.port;
      host = "0.0.0.0";
      openFirewall = true;
      machine-learning.enable = false;
      accelerationDevices = null; # all available devices
      settings.server.externalDomain = "https://photos.juliusboettger.com";
    };

    services.immich-public-proxy = {
      enable = true;
      port = cfg.ppport;
      openFirewall = true;
      immichUrl = "http://localhost:${toString cfg.port}";
      settings.ipp = {
        showGalleryTitle = true;
        allowDownloadAll = 0; # disable
        showMetadata.description = true;
      };
    };

    # reverse-proxy + redirect root to custom shared url "public"
    local.website.extraConfig = ''
      photos.juliusboettger.com {
        reverse_proxy :${toString cfg.ppport}
        rewrite / /s/public
      }
    '';
  };
}
