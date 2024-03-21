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

  # shell alias for shorter fastfetch
  environment.shellAliases.fastfetch-short = "fastfetch -c /etc/dotfiles/fastfetch/wsl/short.jsonc";

  home-manager.users.${variables.username} = { config, ... }: {
    ### symlink dotfiles
    # files in ~/.config/
    xdg.configFile."fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fastfetch/wsl/default.jsonc";
  };
}