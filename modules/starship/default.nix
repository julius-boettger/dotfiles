# shell prompt
args@{ config, lib, pkgs, ... }:
lib.mkModule "starship" config {
  environment.systemPackages = [ pkgs.starship ];

  # set config file location
  environment.variables.STARSHIP_CONFIG = "/etc/dotfiles/modules/starship/starship.toml";
}