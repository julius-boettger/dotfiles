# discord
args@{ config, lib, pkgs, inputs, variables, ... }:
lib.mkModule "discord" config {
  # nixcord for declarative config
  home-manager.sharedModules = [ inputs.nixcord.homeManagerModules.nixcord ];
  home-manager.users.${variables.username} = { config, ... }: {
    programs.nixcord = {
      enable = true;
      # disable discord (enabled by default)
      discord = {
        enable = false;
        vencord.enable = false;
        openASAR.enable = false;
      };
      # use vesktop instead (wayland optimized discord client)
      vesktop = {
        enable = true;
        package = pkgs.unstable.vesktop;
      };

      config.plugins = {
        fakeNitro.enable = true;
        callTimer.enable = true;
        friendsSince.enable = true;
        crashHandler.enable = true;
        volumeBooster.enable = true;
        notificationVolume.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}