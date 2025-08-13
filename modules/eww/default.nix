# build custom widgets
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "eww" config {
  environment.systemPackages = with pkgs; [
    eww
    # for hyprland + eww integration
    hyprland-workspaces 
    # open eww desktop widget on all monitors
    (lib.writeScriptFile "eww-open-everywhere" ./scripts/open-everywhere.sh)
  ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."eww" = {
      source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/eww";
      recursive = true;
    };
  };
}