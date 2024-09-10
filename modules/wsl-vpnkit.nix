# for issues with wsl and company network/vpn
args@{ config, lib, pkgs, inputs, ... }:
{
  options.local.wsl-vpnkit.enable = lib.mkEnableOption "whether to enable wsl-vpnkit";

  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  config = lib.mkIf config.local.wsl-vpnkit.enable {

    wsl.wslConf.network.generateResolvConf = false;
    networking.nameservers = lib.mkDefault [ "8.8.4.4" "8.8.8.8" ];
    boot.tmp.cleanOnBoot = true;

    environment.systemPackages = [ pkgs.unstable.wsl-vpnkit ];
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
  };
}