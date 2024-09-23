# development tools like compilers, build management, containerization, ...
args@{ config, lib, pkgs, ... }:
let
  cfg = config.local.devtools;
in
{
  options.local.devtools = {
    cpp       .enable = lib.mkEnableOption "whether to enable c/c++ devtools";
    rust      .enable = lib.mkEnableOption "whether to enable rust devtools";
    java      .enable = lib.mkEnableOption "whether to enable java devtools";
    docker    .enable = lib.mkEnableOption "whether to enable docker devtools";
    python    .enable = lib.mkEnableOption "whether to enable python devtools";
    javascript.enable = lib.mkEnableOption "whether to enable javascript devtools";
  };

  config = {
    environment.systemPackages = []
      # python
      ++ (if cfg.python.enable then [ (pkgs.python3.withPackages (python-pkgs: [ python-pkgs.virtualenv ])) ] else [])
      # javascript
      ++ (if cfg.javascript.enable then [ pkgs.nodePackages_latest.nodejs ] else [])
      # rust (dont forget to run `rustup toolchain install stable`)
      ++ (if cfg.rust.enable then [ pkgs.rustup ] else [])
      # c/c++
      ++ (if cfg.cpp.enable then with pkgs; [
        gcc # compiler
        meson ninja # build management
      ] else [])
      # dependency management for c/c++/rust
      ++ (if cfg.cpp.enable || cfg.rust.enable then [ pkgs.pkg-config ] else [])
    ;

    # fix for dependency management for c/c++/rust
    environment.variables.PKG_CONFIG_PATH = lib.mkIf (cfg.cpp.enable || cfg.rust.enable)
      "/run/current-system/sw/lib/pkgconfig";

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