# obsidian synchronization server using couchdb
# https://github.com/vrtmrz/obsidian-livesync
args@{ config, lib, ... }:
let
  port = 5984; # couchdb default
  couchdb-pkg = (lib.getNixpkgs "couchdb-aarch64-nixpkgs").couchdb3;
in
lib.mkModule "obsidian-livesync" config {

  ### initial setup
  # set this temporarily and build:
  #services.couchdb.adminPass = "";
  # visit:
  # hostname/_utils#setup
  # hostname/_utils/index.html#verifyinstall
  # hostname/_utils (to create new database like "obsidian")
  # follow:
  # https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md#4-client-setup
  # https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/quick_setup.md
  # dont forget to adjust the plugin settings!

  services.couchdb = {
    enable = true;
    inherit port;
    package = couchdb-pkg;
    # to avoid shell setup script
    # https://github.com/vrtmrz/obsidian-livesync/blob/main/utils/couchdb/couchdb-init.sh
    extraConfig = {
      chttpd = {
        require_valid_user = true;
        enable_cors = true;
        max_http_request_size = 4294967296;
      };

      chttpd_auth.require_valid_user = true;

      httpd = {
        WWW-Authenticate = ''Basic realm="couchdb"'';
        enable_cors = true;
      };

      couchdb.max_document_size = 50000000;

      cors = {
        credentials = true;
        origins = "app://obsidian.md,capacitor://localhost,http://localhost,https://localhost,capacitor://obsidian.juliusboettger.com,http://obsidian.juliusboettger.com,https://obsidian.juliusboettger.com";
      };
    };
  };

  local.website.extraConfig = ''
    obsidian.juliusboettger.com {
      reverse_proxy :${toString port}
    }
  '';
}