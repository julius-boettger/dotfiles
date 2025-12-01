# application launcher
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "rofi" config {
  # emoji picker for rofi
  environment.systemPackages = [ pkgs.rofimoji ];

  home-manager.users.${variables.username} = { config, ... }: {
    programs.rofi = {
      enable = true;
      theme = "transparent"; # own theme
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };

    # write rofimoji config file
    xdg.configFile."rofimoji.rc".text = ''
      action = copy
      skin-tone = neutral
    '';

    # symlink themes to ~
    home.file.".local/share/rofi/themes".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/rofi";
  };
}