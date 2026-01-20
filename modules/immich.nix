# photo management
args@{ config, lib, variables, ... }:
let
  port = 2283; # default immich port
  ppport = 3000; # default public proxy port
in
lib.mkModule "immich" config {
  services.immich = {
    enable = true;
    inherit port;
    host = "0.0.0.0";
    openFirewall = true;
    machine-learning.enable = false;
    accelerationDevices = null; # all available devices
    settings.server.externalDomain = "https://photos.juliusboettger.com";
  };

  services.immich-public-proxy = {
    enable = true;
    port = ppport;
    openFirewall = true;
    immichUrl = "http://localhost:${toString port}";
    settings.ipp = {
      showGalleryTitle = true;
      allowDownloadAll = 0; # disable
      showMetadata.description = true;
    };
  };

  # reverse-proxy + redirect root to custom shared url "public"
  local.website.extraConfig = ''
    photos.juliusboettger.com {
      reverse_proxy :${toString ppport}
      rewrite / /s/public
    }
  '';
}
