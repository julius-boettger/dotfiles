# neofetch but fast
args@{ config, lib, pkgs, ... }:
let
  configPath = "/etc/dotfiles/devices/${config.name}/fastfetch";
in
lib.mkModule "fastfetch" config {
  environment.systemPackages = [ pkgs.fastfetch ];

  # shell alias for shorter fastfetch (which uses device-specific config)
  environment.shellAliases.fastfetch-short = "fastfetch -c ${configPath}/short.jsonc";

  # symlink device-specific config to ~/.config
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    xdg.configFile."fastfetch/config.jsonc".source =
      config.lib.file.mkOutOfStoreSymlink "${configPath}/default.jsonc";
  };
}