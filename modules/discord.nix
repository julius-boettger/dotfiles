# discord
args@{ config, lib, pkgs, inputs, variables, ... }:
let
  discord-pkgs = pkgs.unstable;
in
lib.mkModule "discord" config {
  # nixcord currently doesnt work for me, so just use basic vesktop
  # see https://github.com/KaylorBen/nixcord/issues/93
  environment.systemPackages = [ discord-pkgs.vesktop ];
  # nixcord for declarative config
  /*home-manager.sharedModules = [ inputs.nixcord.homeModules.nixcord ];
  home-manager.users.${variables.username} = { config, ... }: {
    programs.nixcord = {
      enable = true;
      # disable discord (enabled by default)
      discord = {
        enable = false;
        openASAR.enable = false;
        vencord = {
          enable = false;
          # still relevant for vesktop even if not enabled here
          package = discord-pkgs.vencord;
        };
      };
      # use vesktop instead (wayland optimized discord client)
      vesktop = {
        enable = true;
        package = discord-pkgs.vesktop;
      };

      config.plugins = {
        fakeNitro.enable = true;
        #callTimer.enable = true; # makes vesktop crash when joining calls?
        friendsSince.enable = true;
        crashHandler.enable = true;
        volumeBooster.enable = true;
        notificationVolume.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };*/
}