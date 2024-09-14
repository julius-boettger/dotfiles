# 
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "fish" config {
  # fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  environment.variables = {
    fish_color_param = "normal";
    fish_color_error = "yellow";
    fish_color_option = "cyan";
    fish_color_command = "green";
    fish_color_autosuggestion = "brblack";
  };

  # symlink startup script to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."fish/config.fish".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/fish/init.fish";
  };
}