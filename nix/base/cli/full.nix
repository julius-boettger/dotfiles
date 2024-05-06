# more cli config i don't want on every device
args@{ pkgs, variables, ... }:
{
  environment.systemPackages = with pkgs; [
    tldr # summarize man pages
    meson ninja # for building c/c++ projects
    pkg-config # for c/c++/rust dependency management
    librespeed-cli # speedtest
    cbonsai # ascii art bonsai
    asciiquarium-transparent # ascii art aquarium
    # compilers, interpreters, debuggers
    gcc
    rustup
    nodePackages_latest.nodejs
  ];

  ###########################################
  ###########################################
  ########### PROGRAMS / SERVICES ###########
  ###########################################
  ###########################################

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
}