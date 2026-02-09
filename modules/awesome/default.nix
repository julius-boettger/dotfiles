# xorg tiling window manager
args@{ config, lib, ... }:
lib.mkModule "awesome" config {
  services.xserver = {
    enable = true;
    xkb.layout = config.console.keyMap;
    windowManager.awesome.enable = true;
  };

  # symlink config to ~/.config
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    xdg.configFile."awesome" = {
      source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/awesome";
      recursive = true;
    };
  };
}