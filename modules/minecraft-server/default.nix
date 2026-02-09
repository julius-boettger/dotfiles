# host minecraft server
args@{ config, lib, inputs, pkgs, ... }:
{
  options.local.minecraft-server.enable = lib.mkEnableOption "whether to enable minecraft-server";
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  config = lib.mkIf config.local.minecraft-server.enable {

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/srv/minecraft";

      servers.default = {
        enable = true;
        files."server-icon.png" = ./server-icon.png;
        package = pkgs.minecraftServers.fabric-1_21_5;

        serverProperties = {
          white-list = true;
          # default, also needs to be open on router!
          server-port = 25565;

          max-players = 8;
          view-distance = 10;
          simulation-distance = 10;
          jvmOpts = "-Xms1G -Xmx7G"; # min/max memory
          # different quotes to avoid double backspaces for escaping
          motd = ''\u00a73\u00a7lJulius\u00a7b\u00a7l Server\u00a7r\n\u00a7f\u263a \ud83d\udd14 \ud83c\udfa3 \u2600 \u26cf \ud83e\uddea \u266b'';
        };
      };
    };
  };
}