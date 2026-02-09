# terminal
args@{ config, lib, pkgs, ... }:
lib.mkModule "alacritty" config {
  environment.systemPackages = [ pkgs.alacritty ];

  # make some stuff in alacritty look better...? probably subjective
  fonts.fontconfig = {
    subpixel.rgba = "vrgb";
    hinting.style = "full"; # may cause loss of shape, try lower value?
  };

  # symlink config to ~/.config
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    xdg.configFile."alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/alacritty/alacritty.toml";
  };
}