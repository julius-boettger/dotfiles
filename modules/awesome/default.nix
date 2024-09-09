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
      # use absolute path because relative path doesn't symlink submodules (?)
      source = config.lib.file.mkOutOfStoreSymlink /etc/dotfiles/modules/awesome;
      recursive = true;
    };
  };
}