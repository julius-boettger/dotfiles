# effects on audio inputs/outputs, e.g. mic background noise removal
args@{ config, lib, ... }:
lib.mkModule "easyeffects" config {
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    services.easyeffects = {
      enable = true;
    };
  };
}
