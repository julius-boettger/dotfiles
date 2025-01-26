# host minecraft server
args@{ config, lib, inputs, ... }:
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
        package = (lib.getNixpkgs "nix-minecraft").minecraftServers
          .fabric-1_21;

        serverProperties = {
          white-list = true;
          # default, also needs to be open on router!
          server-port = 25565;

          max-players = 8;
          view-distance = 10;
          simulation-distance = 10;
          jvmOpts = "-Xms1G -Xmx7G"; # min/max memory
          # different quotes to avoid double backspaces for escaping
          motd = ''\u00a73\u00a7lJulius \u00a7b\u00a7lServer\u00a7f \u263a\u26cf'';
        };
      };
    };
  };
}