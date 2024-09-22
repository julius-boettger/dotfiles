# secret management with sops
args@{ config, lib, pkgs, inputs, variables, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.local.sops.enable = lib.mkEnableOption "whether to enable sops";
  config = lib.mkIf config.local.sops.enable {

    environment.systemPackages = with pkgs; [
      sops
      ssh-to-age # convert keys
    ];

    # should contain private key generated with ssh-to-age
    sops.age.keyFile = "/home/${variables.username}/.config/sops/age/keys.txt";
  };
}