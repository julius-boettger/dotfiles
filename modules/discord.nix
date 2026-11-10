# discord
args@{ config, lib, pkgs, inputs, ... }:
lib.mkModule "discord" config {
  # nixcord for declarative config
  home-manager.sharedModules = [ inputs.nixcord.homeModules.nixcord ];
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    programs.nixcord = {
      enable = true;
      # disable discord (enabled by default)
      discord = {
        enable = false;
        openASAR.enable = false;
        vencord = {
          enable = false;
          # still relevant for vesktop even if not enabled here
          package = pkgs.local.vencord;
          # !!! ^ currently using local version
          # newer than unstable or vesktop doesnt even start
        };
      };
      # use vesktop instead (wayland optimized discord client)
      vesktop = {
        enable = true;
        package = pkgs.unstable.vesktop;
      };

      config.plugins = {
        fakeNitro.enable = true;
        crashHandler.enable = true;
        volumeBooster.enable = true;
        notificationVolume.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}