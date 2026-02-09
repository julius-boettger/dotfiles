args@{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = config.username;
  };

  networking.hostName = "wsl";

  # usually enabled in modules/base/default.nix, doesnt work here
  boot.loader.systemd-boot.enable = lib.mkForce false;

  local = {
    # for issues with company network/vpn
    wsl-vpnkit.enable = true;
    # git gui (yes, that works with wsl!)
    gitnuro.enable = true;
  };

  # automatic nix garbage collect
  programs.nh.clean.dates = "daily";

  # connect vscode on windows to nixos wsl
  # https://github.com/nix-community/nixos-vscode-server/issues/70
  services.vscode-server = {
    enable = true;
    nodejsPackage = pkgs.nodePackages_latest.nodejs;
  };

  # override git user
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    programs.git.settings.user = {
        name = "";
        email = "";
    };
  };
}
