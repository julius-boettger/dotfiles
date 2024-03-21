{ pkgs, variables, ... }:
{
  wsl = {
    enable = true;
    defaultUser = variables.username;
  };

  # for issues with company network
  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];
  boot.tmp.cleanOnBoot = true;

  home-manager.users.${variables.username} = { config, ... }: {
    ### symlink dotfiles
    # files in ~/.config/
    xdg.configFile = {
      "fish/config.fish".source       = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fish/wsl-init.fish";
      "fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fastfetch/wsl/default.jsonc";   
    };
  };
}