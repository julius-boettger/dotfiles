# photo gallery web app
# https://wiki.nixos.org/wiki/PhotoPrism
args@{ config, lib, pkgs, variables, ... }:
let
  port = 4000;
  main-website = (lib.getPkgs "website").website;
in 
lib.mkModule "photoprism" config {

  # for access from local net
  networking.firewall.allowedTCPPorts = [ port ];
  # use admin password from local sops file
  sops.secrets.admin_password.sopsFile = ./secrets.yaml;

  services.photoprism = {
    enable = true;

    address = "0.0.0.0";
    inherit port;

    passwordFile = config.sops.secrets.admin_password.path;

    # nixos wiki says this should be under /var/lib/private/photoprism
    originalsPath = "/var/lib/private/photoprism/originals";
    # documentation says this should not be under the originalsPath
    importPath = "/var/lib/private/photoprism/import";

    settings = {
      # https://docs.photoprism.app/getting-started/config-options

      # no authentication required
      PHOTOPRISM_PUBLIC = "true";
      # unauthenticaed users shouldn't...
      PHOTOPRISM_READONLY = "true"; # modify photos
      PHOTOPRISM_DISABLE_UPLOADS = "true"; # upload photos
      PHOTOPRISM_DISABLE_SETTINGS = "true"; # change settings

      # website browser tab name
      PHOTOPRISM_SITE_CAPTION = "Julius Böttger's Photos";
      # displayed in footer
      PHOTOPRISM_LEGAL_INFO = "© Julius Böttger. All rights reserved. Reach out for licensing or usage inquiries.";

      # don't really appear anywhere?
      PHOTOPRISM_SITE_TITLE = "Julius Böttger's Photos";
      PHOTOPRISM_SITE_AUTHOR = "Julius Böttger";
      # only used for sharing i think?
      PHOTOPRISM_SITE_URL = "https://photos.juliusboettger.com";

      # looks most like main website
      PHOTOPRISM_DEFAULT_THEME = "Vanta"; 
      PHOTOPRISM_SITE_PREVIEW = "${main-website}/logo/logo-square-with-space.svg";
      # try .ico?
      #PHOTOPRISM_SITE_FAVICON = "/etc/dotfiles/modules/photoprism/favicon.ico";

      # database connection
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";

      ### disable features
      # not needed
      PHOTOPRISM_DISABLE_WEBDAV = "true";
      PHOTOPRISM_DISABLE_RSVGCONVERT = "true";
      # computationally heavy AI features
      PHOTOPRISM_DISABLE_FACES = "true";
      PHOTOPRISM_DISABLE_PLACES = "true";
      #PHOTOPRISM_DISABLE_CLASSIFICATION = "true";
    };
  };

  # database for photoprism
  services.mysql = {
    enable = true;
    package = pkgs.mariadb; # recommended by documentation
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [ {
      name = "photoprism";
      ensurePermissions."photoprism.*" = "ALL PRIVILEGES";
    } ];
  };

  /*local.website.extraConfig = ''
    photos.juliusboettger.com {
      reverse_proxy :${toString port}
    }
  '';*/
}
