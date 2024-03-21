{ pkgs, variables, ... }:
{
  home-manager.users.${variables.username} = { config, ... }: {
    ### symlink dotfiles
    # files in ~/.config/
    xdg.configFile = {
      "fish/config.fish".source       = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fish/default-init.fish";
      "fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fastfetch/default.jsonc";   
    };
  };
}