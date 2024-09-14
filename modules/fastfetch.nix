# neofetch but fast
args@{ config, lib, pkgs, variables, device, ... }:
let
  configPath = "/etc/dotfiles/devices/${device.internalName}/fastfetch";
in
lib.mkModule "fastfetch" config {
  environment.systemPackages = [ pkgs.fastfetch ];

  # shell alias for shorter fastfetch (which uses device-specific config)
  environment.shellAliases.fastfetch-short = "fastfetch -c ${configPath}/short.jsonc";

  # symlink device-specific config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."fastfetch/config.jsonc".source =
      config.lib.file.mkOutOfStoreSymlink "${configPath}/default.jsonc";
  };
}