args@{ pkgs, variables, ... }:
{
  imports = [ ./../../modules/base/cli/full.nix ];

  wsl = {
    enable = true;
    defaultUser = variables.username;
  };

  environment.systemPackages = with pkgs; [
    unstable.gitnuro # git gui (yes, that works with wsl)
    unstable.wsl-vpnkit # for issues with company vpn
  ];

  # connect vscode on windows to nixos wsl
  services.vscode-server = {
    enable = true;
    nodejsPackage = pkgs.nodePackages_latest.nodejs;
  };

  # for issues with company network
  wsl.wslConf.network.generateResolvConf = false;
  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];
  boot.tmp.cleanOnBoot = true;

  # automatic garbage collection to free space
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old";
  };

  # for issues with company vpn
  environment.shellAliases = {
    vpn-status =      "systemctl status wsl-vpnkit | sed -n '/Active: /s/Active: //p' | awk '{$1=$1};1'";
    vpn-start  = "sudo systemctl start  wsl-vpnkit";
    vpn-stop   = "sudo systemctl stop   wsl-vpnkit";
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
}