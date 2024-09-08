# more cli config i don't want on every device
args@{ config, lib, pkgs, variables, ... }:
{
  options.local.base.cli.full.enable = lib.mkEnableOption "whether to enable full cli config";

  config = lib.mkIf config.local.base.cli.full.enable {

    environment.systemPackages = with pkgs; [
      tldr # summarize man pages
      meson ninja # for building c/c++ projects
      pkg-config # for c/c++/rust dependency management
      librespeed-cli # speedtest
      # compilers, interpreters, debuggers
      gcc # c/c++
      cargo # rust
      nodePackages_latest.nodejs # javascript
    ];

    # fix pkg-config by pointing it in the right way
    environment.variables.PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";

    # java
    programs.java = {
      enable = true;
      package = pkgs.unstable.jdk;
    };

    # docker
    virtualisation.docker = {
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