# xorg tiling window manager
args@{ config, lib, variables, ... }:
lib.mkModule "awesome" config {
  services.xserver = {
    enable = true;
    xkb.layout = config.console.keyMap;
    windowManager.awesome.enable = true;
  };

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."awesome" = {
      source = config.lib.file.mkOutOfStoreSymlink ./.;
      recursive = true;
    };
  };
}