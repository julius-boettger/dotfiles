# development tools like compilers, build management, containerization, ...
args@{ config, lib, pkgs, ... }:
let
  cfg = config.local.devtools;
in
{
  options.local.devtools = {
    java  .enable = lib.mkEnableOption "whether to enable java devtools";
    docker.enable = lib.mkEnableOption "whether to enable docker devtools";
    python.enable = lib.mkEnableOption "whether to enable python devtools";
  };

  config = {
    # python
    environment.systemPackages = lib.optionals cfg.python.enable [
      (pkgs.python3.withPackages (p: with p; [ virtualenv ]))
    ];

    # java
    programs.java = lib.mkIf cfg.java.enable {
      enable = true;
      package = pkgs.unstable.jdk;
    };

    # docker
    virtualisation.docker = lib.mkIf cfg.docker.enable {
      enable = true;
      # better for security than adding user to "docker" group
      rootless = {
        enable = true;
        # make rootless instance the default
        setSocketVariable = true;
      };
    };
  };
}