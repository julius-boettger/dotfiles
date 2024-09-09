args@{ pkgs, variables, ... }:
{
  wsl = {
    enable = true;
    defaultUser = variables.username;
  };

  # for issues with company network/vpn
  wsl.wslConf.network.generateResolvConf = false;
  local.wsl-vpnkit.enable = true;

  # git gui (yes, that works with wsl!)
  local.gitnuro.enable = true;

  # automatic garbage collection to free space
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old";
  };

  # connect vscode on windows to nixos wsl
  # https://github.com/nix-community/nixos-vscode-server/issues/70
  services.vscode-server = {
    enable = true;
    nodejsPackage = pkgs.nodePackages_latest.nodejs;
  };
}