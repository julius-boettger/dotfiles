# xorg tiling window manager
args@{ config, lib, pkgs, inputs, variables, device, ... }:
lib.mkModule "awesome" config {
  services.xserver.windowManager.awesome.enable = true;

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."awesome" = {
      source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/awesome";
      recursive = true;
    };
  };
}