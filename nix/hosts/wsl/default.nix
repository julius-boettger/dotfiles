{ pkgs, variables, ... }:
{
  environment.variables.NIX_FLAKE_DEFAULT_HOST = "wsl";

  wsl = {
    enable = true;
    defaultUser = variables.username;
  };

  # for issues with company network
  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];
  boot.tmp.cleanOnBoot = true;

  # for issues with company vpn
  environment.systemPackages = with pkgs; [ unstable.wsl-vpnkit ];
  environment.shellAliases = {
    vpn-start = "sudo systemctl start wsl-vpnkit";
    vpn-stop  = "sudo systemctl stop  wsl-vpnkit";
  };
  systemd.services.wsl-vpnkit = {
    enable = true;
    description = "wsl-vpnkit";
    serviceConfig = {
      ExecStart = "${pkgs.unstable.wsl-vpnkit}/bin/wsl-vpnkit";
      Type = "idle";
      Restart = "always";
      KillMode = "mixed";
    };
  };

  # shell alias for shorter fastfetch
  environment.shellAliases.fastfetch-short = "fastfetch -c /etc/dotfiles/fastfetch/wsl/short.jsonc";

  home-manager.users.${variables.username} = { config, ... }: {
    ### symlink dotfiles
    # files in ~/.config/
    xdg.configFile."fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fastfetch/wsl/default.jsonc";
  };
}