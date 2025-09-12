# photo gallery web app
args@{ config, lib, pkgs, variables, ... }:
let
  lychee = pkgs.buildNpmPackage rec {
    pname = "lychee";
    version = "6.9.1";

    src = pkgs.fetchFromGitHub {
      owner = "LycheeOrg";
      repo = "Lychee";
      rev = "v${version}";
      sha256 = "sha256-VBGWq/k43SJoOc0+Lmv3ajqJkx7vigQedGNsjd4tqsY=";
    };

    npmDepsHash = "sha256-55YZKiaRkAhPSGMk+tseRJEslAPco3Q/JIJnjn7DWJE=";

    buildInputs = [ pkgs.php ];

    nativeBuildInputs = with pkgs.php; [
      packages.composer
      packages.composer-local-repo-plugin
      composerHooks.composerInstallHook
    ];

    composerRepository = pkgs.php.mkComposerRepository {
      inherit pname version src;
      composerNoDev = true;
      composerNoPlugins = true;
      composerNoScripts = true;
      vendorHash = "sha256-2/tsI5ottF04RJTmihynrwWymGwC1b5pU9k2gjFtoaw=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
    '';
  };
in 
lib.mkModule "lychee" config {
  local.website.extraConfig = ''
    photos.juliusboettger.com {
      root * ${lychee}/public
      php_fastcgi unix/${config.services.phpfpm.pools.lychee.socket}
      file_server
    }
  '';

  services.phpfpm.pools.lychee = {
    user = "caddy";
    group = "caddy";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "lychee" ];
    ensureUsers = [ {
      name = "lychee";
      ensurePermissions."lychee.*" = "ALL PRIVILEGES";
    } ];
  };
}
